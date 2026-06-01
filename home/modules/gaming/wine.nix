{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming.wine;
in
{
  options.my.gaming.wine = with lib; {
    enable = mkEnableOption "Wine gaming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wineWow64Packages.waylandFull
      # wineWow64Packages.full
      wineWow64Packages.fonts
    ];
  };
}
