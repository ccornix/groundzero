{ lib, ... }:

{
  imports = [
    ./gruvbox-dark.nix
  ];

  my.themes.gruvboxDark.enable = lib.mkDefault true;
}
