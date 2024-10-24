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
      loaded_netrw = true;
      loaded_netrwPlugin = true;
    };
    opts = {
      completeopt = [ "menu" "menuone" "noselect" ];
      mouse = "";
      termguicolors = true;  # if not legacy mode
      textwidth = 79;
      formatexpr = "";
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      foldenable = false;
      foldmethod = "expr";
      foldexpr = "nvim_tressitter#foldexpr()";
      splitright = true;
      splitbelow = true;
      number = true;
      relativenumber = true;
      colorcolumn = "+1";
      signcolunb = "number";
      list = true;
      listchars = { tab = "▸ "; trail = "·"; };
      updatetime = 250;
      incsearch = true;
      hlsearch = false;
      ignorecase = true;
      smartcase = true;
    };
    keymaps = [
    ];
    plugins.lualine.enable = true;
  };
}
