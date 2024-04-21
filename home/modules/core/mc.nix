{ config, pkgs, ... }:

let
  hotlistDirs = [
    "/"
    config.home.homeDirectory
    config.xdg.dataHome
    "/run/media/${config.home.username}" # TODO: is there a canonical repr?
    "/nfs/nas"
  ];
in
{
  xdg = {
    enable = true;
    configFile = {
      "mc/hotlist".text = builtins.concatStringsSep "\n" (
        map (x: ''ENTRY "${x}" URL "${x}"'') hotlistDirs
      );
    };
  };

  home.packages = [ pkgs.mc ];
}
