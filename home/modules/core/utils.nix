{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fastfetch
    pkgs.unzip
  ];
}
