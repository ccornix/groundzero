{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming.quake3e;
in
{
  options.my.gaming.quake3e = with lib; {
    enable = mkEnableOption "Quake3e";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        pkgs.quake3e
      ];
    };
  };
}
