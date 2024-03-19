{ pkgs, inputs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home.packages = with pkgs; [
    inputs.home-manager.packages.${system}.home-manager

    htop
    mc
    neofetch
    unzip
  ];
}
