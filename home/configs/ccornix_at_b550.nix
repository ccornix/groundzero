{ inputs, config, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  wallpaperPkg = inputs.wallpapers.packages.${system}.kochflakes3.override {
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
      wine.enable = true;
    };
    virtualization.enable = true;
  };

  home.stateVersion = "23.11";
}
