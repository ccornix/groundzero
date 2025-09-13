{ self, nixpkgs, ... }@inputs:

let
  hosts = [
    "b550m"
    "x13g2"
    # TODO: remove these hosts
    # "c236m"
    # "b560"
  ];

  mkNixosConfig =
    host:
    nixpkgs.lib.nameValuePair host (
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./${host}.nix ];
      }
    );
in
self.lib.mapListToAttrs mkNixosConfig hosts
