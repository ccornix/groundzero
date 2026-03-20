# Customized installer ISO image

{ inputs, pkgs, lib, modulesPath, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment = {
    systemPackages = [
      pkgs.git
      pkgs.tmux
    ];
    variables.FLAKE0 = builtins.toString inputs.self.outPath;
  };

  networking = {
    networkmanager.enable = true;
    wireless.enable = false; # Disable wpa_supplicant
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Clear misleading default help
  services.getty.helpLine = lib.mkForce "";

  users.users.nixos = {
    password = "nixos";
    initialHashedPassword = lib.mkForce null;
  };

  image.fileName = lib.mkForce "nixos-${system}.iso";
}
