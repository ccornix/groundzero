# Config of swaylock, screen locker utility for Sway

{ config, lib, ... }:

let
  inherit (config.my.desktop.theme) background termFont topBar;
  cfg = config.my.desktop.swaylock;
in
{
  options.my.desktop.swaylock.enable = lib.mkEnableOption "swaylock";

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      configFile."swaylock/config".text = with config.colorScheme.palette; ''
        show-keyboard-layout
        indicator-caps-lock
        scaling=fill
        font=${termFont.name} ${termFont.style}
        font-size=${toString (topBar.fontSize * 2)}
        indicator-radius=100
        indicator-thickness=20
      '';
    }; # xdg
  }; # config
}
