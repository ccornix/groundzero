{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.neofetch
    pkgs.unzip
  ];
}
