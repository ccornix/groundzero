{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming.devilutionx;
in
{
  options.my.gaming.devilutionx = with lib; {
    enable = mkEnableOption "devilutionX";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        innoextract # For extracting data from GoG Windows exe-files
        my.devilutionx
      ];

      shellAliases = {
        # HACK: fix SDL error
        devilutionx = "SDL_VIDEODRIVER=x11 devilutionx";
      };
    };
  };
}
