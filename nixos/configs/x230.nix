# ThinkPad X230 (coreboot)

{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.disko.nixosModules.disko
    inputs.self.nixosModules.default
    ./ccornix.nix
  ];

  my = {
    desktop.enable = true;
    network = {
      shares.enable = true;
      tailscale.enable = true;
    };
    virtualization.enable = true;
    zfs.enable = true;
  };

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "sd_mod"
      "sdhci_pci"
      "uas"
      "xhci_pci"
    ];
    kernelModules = [ "kvm-intel" ];
    blacklistedKernelModules = [ "mei" "mei_me" ];

    # Let disko set up `boot.loader.grub.devices`
    loader.grub.enable = true;

    # HACK: silence mdadm warning on missing MAILADDR or PROGRAM setting
    swraid.mdadmConf = ''
      PROGRAM ${pkgs.coreutils}/bin/true
    '';
  };

  # neededForBoot flag is not settable from disko
  fileSystems = {
    "/var/log".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  swapDevices = [ ];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault
      config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking.hostName = "x230";

  nixpkgs.hostPlatform = "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  system.stateVersion = "23.11";

  disko.devices = {
    disk = {
      system1 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x57c35481a3ac4f8c";
        content = {
          type = "gpt";
          partitions = {
            biosboot1 = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            boot1 = {
              size = "512M";
              content = {
                type = "mdraid";
                name = "boot";
              };
            }; # boot1
            zfs1 = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            }; # zfs1
          }; # partitions
        }; # content
      }; # system1
      system2 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x57c35481a213e4a4";
        content = {
          type = "gpt";
          partitions = {
            biosboot2 = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            boot2 = {
              size = "512M";
              content = {
                type = "mdraid";
                name = "boot";
              };
            }; # boot2
            zfs2 = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            }; # zfs2
          }; # partitions
        }; # content
      }; # system2
    }; # disk
    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/boot";
        }; # content
      }; # boot
    }; # mdadm
    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          dnodesize = "auto";
          canmount = "off";
          xattr = "sa";
          relatime = "on";
          normalization = "formD";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        mode = "mirror";
        datasets = {
          local = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          safe = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "local/reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              reservation = "5GiB";
            };
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = ''
              zfs snapshot rpool/local/root@blank
            '';
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              atime = "off";
              canmount = "on";
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "local/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
        }; # datasets
      }; # rpool
    }; # zpool
  }; # disko.devices
}
