# Config of foot, a Wayland-native terminal emulator

{ config, lib, ... }:

let
  inherit (config.my.desktop.theme) termFont;
  cfg = config.my.desktop.foot;
  font = "${termFont.name}:size=${toString termFont.size}";
in
{
  options.my.desktop.foot.enable = lib.mkEnableOption "foot terminal emulator";

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          inherit font;
          dpi-aware = "no";
        };
        scrollback = {
          lines = 1000;
        };
      }; # settings
    }; # programs.foot
  }; # config
}
