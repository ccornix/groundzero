{ config, lib, ... }:

let
  cfg = config.my.network.netbird;
in
{
  options.my.network.netbird = {
    enable = lib.mkEnableOption "Netbird";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        { directory = "/var/lib/netbird"; mode = "u=rwx,g=,o="; }
      ];
    };

    services.netbird.clients.wt0 = {
      port = 51821;
      ui.enable = false;
      openFirewall = true;
      openInternalFirewall = true;
    };
  };
}
