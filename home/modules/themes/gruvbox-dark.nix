# Gruvbox Dark theme
#
# Based on:
# https://github.com/morhetz/gruvbox

{ config, pkgs, lib, ... }:

let
  cfg = config.my.themes.gruvboxDark;

  colors = {
    dark0_hard  = "1d2021";
    dark0       = "282828";
    dark0_soft  = "32302f";
    dark1       = "3c3836";
    dark2       = "504945";
    dark3       = "665c54";
    dark4       = "7c6f64";
    dark4_256   = "7c6f64";
    gray_245    = "928374";
    gray_244    = "928374";
    light0_hard = "f9f5d7";
    light0      = "fbf1c7";
    light0_soft = "f2e5bc";
    light1      = "ebdbb2";
    light2      = "d5c4a1";
    light3      = "bdae93";
    light4      = "a89984";
    light4_256  = "a89984";
    bright_red     = "fb4934";
    bright_green   = "b8bb26";
    bright_yellow  = "fabd2f";
    bright_blue    = "83a598";
    bright_purple  = "d3869b";
    bright_aqua    = "8ec07c";
    bright_orange  = "fe8019";
    neutral_red    = "cc241d";
    neutral_green  = "98971a";
    neutral_yellow = "d79921";
    neutral_blue   = "458588";
    neutral_purple = "b16286";
    neutral_aqua   = "689d6a";
    neutral_orange = "d65d0e";
  };
in
{
  options.my.themes.gruvboxDark = {
    enable = lib.mkEnableOption "Gruvbox Dark theme";

    background = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to the desktop background image.
      '';
      default = ../../.local/share/backgrounds/gruvbox-wallhaven-3lyrvy.png;
    };
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
    };

    programs.bash.bashrcExtra = ''
      if [[ $(tty) != /dev/tty* ]]; then
        alias mc='MC_SKIN=gruvbox256 mc'
      fi
    '';
    xdg.dataFile."mc/skins/gruvbox256.ini".source = (
      ../../.local/share/mc/skins/gruvbox256.ini
    );

    programs.helix.settings.theme = "gruvbox";

    programs.foot.settings.colors = with colors; {
      background = dark0;
      foreground = light1;

      # Normal colors
      regular0 = dark0; # Black
      regular1 = neutral_red; # Red
      regular2 = neutral_green; # Green
      regular3 = neutral_yellow; # Yellow
      regular4 = neutral_blue; # Blue
      regular5 = neutral_purple; # Magenta
      regular6 = neutral_aqua; # Cyan
      regular7 = light4; # White

      # Bright colors
      bright0 = gray_245; # Black
      bright1 = bright_red; # Red
      bright2 = bright_green; # Green
      bright3 = bright_yellow; # Yellow
      bright4 = bright_blue; # Blue
      bright5 = bright_purple; # Magenta
      bright6 = bright_aqua; # Cyan
      bright7 = light1; # White
    };

    xdg.configFile."swaylock/config".text = with colors; ''
      image=${toString config.my.themes.gruvboxDark.background}
      bs-hl-color=${bright_yellow}
      caps-lock-bs-hl-color=${bright_orange}
      key-hl-color=${light4}
      caps-lock-key-hl-color=${bright_orange}
      inside-color=${light4}
      inside-clear-color=${bright_green}
      inside-ver-color=${bright_purple}
      inside-wrong-color=${bright_red}
      layout-bg-color=${light4}
      layout-border-color=${dark0}
      layout-text-color=${dark0}
      ring-color=${gray_245}
      ring-clear-color=${neutral_green}
      ring-ver-color=${neutral_purple}
      ring-wrong-color=${neutral_red}
      separator-color=${dark0}
      text-color=${dark0}
      text-clear-color=${dark0}
      text-ver-color=${dark0}
      text-wrong-color=${dark0}
    '';

    wayland.windowManager.sway.config.output = {
      "*" = {
        bg = "${toString config.my.themes.gruvboxDark.background} fill #000000";
      };
    };

    programs.i3status-rust = {
      bars.default = with colors; {
        settings.theme = {
          theme = "plain";
          overrides = {
              separator = " ";
              idle_bg = "#${dark0}";
              idle_fg = "#${light1}";
              info_bg = "#${dark0}";
              info_fg = "#${light1}";
              good_bg = "#${dark0}";
              good_fg = "#${light1}";
              critical_bg = "#${dark0}";
              critical_fg = "#${bright_red}";
              warning_bg = "#${dark0}";
              warning_fg = "#${bright_orange}";
              separator_bg = "#${dark0}";
              separator_fg = "#${light1}";
          };
        };
      };
    };

  }; # config
}
