{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.my.gaming.quake3e;

  inherit (pkgs.stdenv.hostPlatform) system;
  myPkgs = inputs.self.packages.${system};
in
{
  options.my.gaming.quake3e = with lib; {
    enable = mkEnableOption "Quake3e";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        myPkgs.quake3e
        pkgs.wayland-utils
      ];
    };
  };
}
