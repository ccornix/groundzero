{ inputs, config, ... }:

let
  inherit (inputs) nix-colors;
in
{
  imports = [ nix-colors.homeManagerModule ];

  colorscheme = nix-colors.colorSchemes.decaf;

  programs.dircolors.enable = true;

  home.sessionVariables = {
    NEWT_COLORS_FILE = "${config.xdg.configHome}/newt/colors";
    MY_BASE16_COLORSCHEME = config.colorScheme.slug;
  };

  xdg.configFile."newt/colors".source = ../../.config/newt/colors;
}
