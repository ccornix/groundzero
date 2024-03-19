# NOTE: Since libvirt network bridge creation is not (yet) declarative,
#
# sudo virsh net-autostart default && sudo virsh net-start default
#
# needs to be executed after installation.

{ config, pkgs, lib, ... }:

let
  cfg = config.my.virtualization;
in
{
  options.my.virtualization = {
    enable = lib.mkEnableOption "virtualization";
    # FIXME: detect it from disko config?
    persistent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to bind /var/lib/libvirt from persistent storage.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = [ pkgs.virt-manager ];

    environment.persistence."/persist" = lib.mkIf cfg.persistent {
      directories = [ "/var/lib/libvirt" ];
    };
  };
}
