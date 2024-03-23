{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.my.gaming.devilutionx;

  inherit (pkgs.stdenv.hostPlatform) system;
  myPkgs = inputs.self.packages.${system};
in
{
  options.my.gaming.devilutionx = with lib; {
    enable = mkEnableOption "devilutionX";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        pkgs.innoextract # For extracting data from GoG Windows exe-files
        myPkgs.devilutionx
      ];

      shellAliases = {
        # HACK: fix SDL error
        devilutionx = "SDL_VIDEODRIVER=x11 devilutionx";
      };
    };
  };
}
