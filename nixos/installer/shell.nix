{ config, pkgs, inputs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  name = "installer-shell";
  buildInputs = [
    pkgs.coreutils
    pkgs.disko
    pkgs.jq
    pkgs.mkpasswd
    pkgs.wget
    pkgs.unzip
    pkgs.util-linux
    pkgs.zfs
  ];
  shellHook = ''
    export PATH="${builtins.toString ./.}:$PATH"
  '';

  # Environment variables
  NIX_CONFIG = "experimental-features = nix-command flakes";
  TARGET_HOST = config.networking.hostName;
  FLAKE_URI = builtins.toString inputs.self.outPath;
}
