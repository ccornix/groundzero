# Customized installer ISO image

{ inputs, pkgs, lib, modulesPath, ... }:

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
    wireless.enable = false;  # Disable wpa_supplicant
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.nixos.password = "nixos";

  isoImage = {
    isoName = lib.mkForce "nixos.iso";
    # Reduce compression
    # https://github.com/NixOS/nixpkgs/blob/50f9b3107a09ed35bbf3f9ab36ad2683619debd2/nixos/lib/make-squashfs.nix#L8Compression
    squashfsCompression = "zstd -Xcompression-level 6";
  };
}
