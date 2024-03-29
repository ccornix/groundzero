{ inputs, config, pkgs, ... }:

let
  inherit (inputs) wallpapers;
  inherit (pkgs.stdenv.hostPlatform) system;
  wallpaperPkg = wallpapers.packages.${system}.kochflakes3.override {
    palette = builtins.attrValues config.colorScheme.palette;
    width = config.my.primaryDisplayResolution.horizontal;
  };
in
{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop = {
      enable = true;
      theme.wallpaper.path = wallpaperPkg.filePath;
    };
    gaming = {
      devilutionx.enable = true;
      diablo2.enable = true;
    };
  };

  home.stateVersion = "23.11";

  services.kanshi.profiles = {
    undocked = {
      outputs = [
        { criteria = "eDP-1"; }
      ];
    };
    docked = {
      outputs = [
        {
          criteria = "eDP-1";
          position = "1920,0";
        }
        {
          # Use make-model-serial criterion for external monitors as the name
          # (DP-?) may change when reconnected. Get it using:
          #     swaymsg -t get_outputs
          criteria = "Iiyama North America PL2493H 1211424213213";
          position = "0,0";
        }
      ];
    };
  };
}
