# Custom Ryzen desktop PC (B550)

{ inputs, config, lib, ... }:

{
  imports = [
    inputs.nixpkgs.nixosModules.notDetected
    inputs.disko.nixosModules.disko
    inputs.self.nixosModules.default
    ./ccornix.nix
  ];

  my = {
    containers.claude.enable = true;
    desktop = {
      enable = true;
      brotherMfp.enable = true;
    };
    forgejo.runner.enable = true;
    gaming = {
      devilutionx.enable = true;
      diablo2.enable = true;
    };
    hardware = {
      ddcci.enable = true;
      rasdaemon.enable = true;
    };
    network = {
      shares.enable = true;
      netbird.enable = true;
      tailscale.enable = true;
    };
    # virtualization.enable = true;
    zfs.enable = true;
  };

  # NOTE: experimental
  services.guix.enable = true;

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ "amdgpu" ];
    };
    blacklistedKernelModules = [ "k10temp" ];
    extraModulePackages = [ config.boot.kernelPackages.zenpower ];
    kernelModules = [ "kvm-amd" "nct6775" "zenpower" ];
    kernelParams = [ "amd_pstate=active" ];
    loader.systemd-boot.enable = true;
  };

  # neededForBoot flag is not settable from disko
  fileSystems = {
    "/var/log".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  swapDevices = [ ];

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault
      config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    hostName = "b550";
    # FIXME
    # interfaces.<name>.wakeOnLan.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  power.ups = {
    enable = true;
    ups = {
      "eaton5e" = {
        driver = "usbhid-ups";
        port = "auto";
      };
    };
    users.upsmon = {
      passwordFile = "/persist/etc/nut/upsmon.password";
      upsmon = "primary";
    };
    upsmon.monitor."eaton5e" = {
      user = "upsmon";
      type = "primary";
    };
  };

  # The state dir holds only the ephemeral driver socket, so it isn't persisted.
  # Because impermanence wipes the root on every boot and nothing else creates the
  # dir, recreate it here so upsd has somewhere to place its socket.
  systemd.tmpfiles.rules = [ "d /var/lib/nut 0770 root nut -" ];

  # WORKAROUND: the power.ups module orders the services upsmon -> upsd -> upsdrv,
  # i.e. the driver starts last, so on boot upsd/upsmon poll before usbhid-ups has
  # created its socket ("No such file", "Driver not connected", "Variable not
  # supported"). Reverse the chain to upsdrv -> upsd -> upsmon so the driver (with
  # its staged variables) is up before anything connects. mkForce clears the
  # module's edges on both sides to avoid a cyclic ordering; systemd's target
  # ordering is kept.
  systemd.services.upsdrv = {
    after = lib.mkForce [ ];
    before = lib.mkForce [ ];
  };
  systemd.services.upsd = {
    after = lib.mkForce [ "network.target" "upsdrv.service" ];
    before = lib.mkForce [ ];
  };
  systemd.services.upsmon.after = lib.mkForce [ "network.target" "upsd.service" ];

  system.stateVersion = "25.05";

  disko.devices = {
    disk = {
      system = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4e805a4b";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                # WORKAROUND: Fix world-accessible /boot/loader/random-seed
                # https://github.com/nix-community/disko/issues/527#issuecomment-1924076948
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          }; # partitions
        }; # content
      }; # system
    }; # disk
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
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };

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
          "local/gnu" = {
            type = "zfs_fs";
            mountpoint = "/gnu";
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
