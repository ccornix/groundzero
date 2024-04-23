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
  home.packages = [ pkgs.mc ];

  xdg = {
    enable = true;
    configFile = {
      "mc/hotlist".text = builtins.concatStringsSep "\n" (
        map (x: ''ENTRY "${x}" URL "${x}"'') hotlistDirs
      );
      "mc/mc.ext.ini".text = builtins.concatStringsSep "\n" [ ''
         #### Custom associations ###

         [wmf]
         Type=^Windows\ metafile
         Include=image

         [emf]
         Type=^Windows\ Enhanced\ Metafile
         Include=image

        ''
        (builtins.readFile (pkgs.mc.outPath + "/etc/mc/mc.ext.ini"))
      ];
    };
  };
}
