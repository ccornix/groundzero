{ self, nixpkgs, ... } @ inputs:

let
  hosts = [
    "c236m"
    # "b550"
    # "b560"
    "x13g2"
  ];

  mkNixosConfig = host: nixpkgs.lib.nameValuePair host (
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./${host}.nix ];
    }
  );
in
self.lib.mapListToAttrs mkNixosConfig hosts
