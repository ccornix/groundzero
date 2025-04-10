{ self, nixpkgs, ... } @ inputs:

let
  inherit (nixpkgs) lib;

  hosts = [
    "b550"
    "b560"
    "x13g2"
  ];

  mkNixosConfig = host: lib.nameValuePair host (
    lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./${host}.nix ];
    }
  );
in
self.lib.mapListToAttrs mkNixosConfig hosts
