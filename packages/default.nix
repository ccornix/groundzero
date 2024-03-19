{ nixpkgs, home-manager, ... }: system:

let
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  inherit (home-manager.packages.${system}) home-manager;
  devilutionx = pkgs.callPackage ./devilutionx.nix { };
}
