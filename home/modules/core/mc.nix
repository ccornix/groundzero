{ config, pkgs, ... }:

let
  inherit (config.home) username;
in
{
  xdg = {
    enable = true;
    configFile = {
      "mc/hotlist".text = ''
        ENTRY "/" URL "/"
        ENTRY "/home/${username}" URL "/home/${username}"
        ENTRY "/run/media/${username}" URL "/run/media/${username}"
        ENTRY "/nfs/nas" URL "/nfs/nas"
      '';
    };
  };

  home.packages = [ pkgs.mc ];
}
