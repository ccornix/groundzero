# Desktop theme settings

{ config, pkgs, lib, ... }:

let
  cfg = config.my.desktop.theme;

  getGtkPkg = mod:
    let
      pkg = (builtins.getAttr mod config.gtk).package;
    in
    lib.optional (pkg != null) pkg;
in
{
  options.my.desktop.theme = {
    enable = lib.mkEnableOption "custom desktop theme";

    termFont = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "Iosevka Term Nerd Font";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = (
          # Not all Nerd fonts are needed
          pkgs.nerdfonts.override { fonts = [ "IosevkaTerm" ]; }
        );
      };

      style = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "Regular";
      };

      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 16;
      };
    }; # termFont

    topBar = {
      fontSize = lib.mkOption {
        type = lib.types.ints.positive;
        default = cfg.termFont.size;
      };

      height = lib.mkOption {
        type = lib.types.ints.positive;
        default = cfg.topBar.fontSize + 9;
      };
    }; # topBar

    cursorTheme = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "Vanilla-DMZ";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.vanilla-dmz;
      };

      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 24;
      };
    };
  }; # options.my.desktop.theme

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        corefonts # MS TrueType core fonts

        cfg.termFont.package

        # gsettings-desktop-schemas

        # Needed for proper GTK and QT5 theming
        gtk-engine-murrine
        gnome-themes-extra
        libsForQt5.qtstyleplugins
      ];

      sessionVariables = {
        # Add all theme directories to XDG_DATA_DIRS
        XDG_DATA_DIRS = (
          (
            builtins.foldl' (s: p: s + "${p.out}/share:") "" (
              (getGtkPkg "theme")
              ++ (getGtkPkg "iconTheme")
              ++ (getGtkPkg "cursorTheme")
            )
          ) + "$XDG_DATA_DIRS"
        );
        # SVG loader for pixbuf (needed for GTK svg icon themes)
        GDK_PIXBUF_MODULE_FILE =
          "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache";
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      }; # sessionVariables
    }; # home

    gtk = {
      enable = true;
      font = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
        size = cfg.termFont.size;
      };
      inherit (cfg) cursorTheme;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3.bookmarks = [ ];
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    fonts.fontconfig.enable = true;

    xdg.enable = true;
  }; # config
}
