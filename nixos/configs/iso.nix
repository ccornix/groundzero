# Customized AMD64 installer ISO image

{ inputs, pkgs, ... }:

let
  modulesPath = "${input.nixpkgs}/nixos/modules";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.disko.nixosModules.disko
  ];

  environment = {
    systemPackages = [
      pkgs.git
      pkgs.tmux
    ];
    variables.FLAKE0 = builtins.toString inputs.self.outPath;
  };

  users.users.nixos.password = "nixos";

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

  # Reduce compression
  # https://github.com/NixOS/nixpkgs/blob/50f9b3107a09ed35bbf3f9ab36ad2683619debd2/nixos/lib/make-squashfs.nix#L8Compression
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
}
