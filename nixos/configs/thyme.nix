# FIXME: ThinkPad X230 (coreboot)

{ inputs, config, lib, ... }:

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
      # FIXME: fill
      # interfaces = {
      #   wired = { wired0 = ""; };
      #   wireless = { wireless0 = ""; };
      # };
      shares.enable = true;
      tailscale.enable = true;
    };
    virtualization.enable = true;
    zfs.enable = true;
  };

  boot = {
    initrd.availableKernelModules = [
      # FIXME
    ];
    kernelModules = [ "kvm-intel" ];

    # FIXME: GRUB
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
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  networking.hostName = "thyme";

  nixpkgs.hostPlatform = "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  system.stateVersion = "23.11";

  disko.devices = {
    disk = {
      system1 = {
        type = "disk";
        device = "/dev/disk/by-id/TODO";
        content = {
          type = "gpt";
          partitions = {
            # TODO
          }; # partitions
        }; # content
      }; # system1
      system2 = {
        type = "disk";
        device = "/dev/disk/by-id/TODO";
        content = {
          type = "gpt";
          partitions = {
            # TODO
          }; # partitions
        }; # content
      }; # system2
    }; # disk
    # TODO
  }; # disko.devices
}
