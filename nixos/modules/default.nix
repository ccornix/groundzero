{ lib, ... }:

{
  imports = [
    ./core
    ./desktop
    ./gaming
    ./network
    ./virtualization
    ./zfs
  ];

  options.my.flakeURI = lib.mkOption {
    type = lib.types.nonEmptyStr;
    default = "github:ccornix/groundzero";
    description = ''
      URI of the NixOS configuration flake. Can be set to point to a local
      repository, too.
    '';
  };
}
