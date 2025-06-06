# ECC RAM monitoring for MCE events
# https://wiki.archlinux.org/title/Machine-check_exception
# https://wiki.gentoo.org/wiki/ECC_RAM

{ config, lib, ... }:

let
  cfg = config.my.hardware.rasdaemon;
in
{
  options.my.hardware.rasdaemon = {
    enable = lib.mkEnableOption "rasdaemon for ECC RAM monitoring";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/rasdaemon"; mode = "u=rwx,g=rx,o=rx"; }
      ];
    };

    hardware.rasdaemon.enable = true;
  };
}
