{ pkgs, inputs, ... }:

let
  inherit (inputs) nixvim;
in
{
  imports = [ nixvim.homeManagerModules.nixvim ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    globals = {
      mapleader = ",";
    };
    opts = {
    };
    keymaps = [
    ];
    plugins.lualine.enable = true;
  };
}
