{ self, nixpkgs, ... } @ inputs:

let
  hosts = [
    "b550"
    # FIXME: enable
    # "b560"
    # FIXME: remove
    # "c236m"
    "x13g2"
    "x230"
  ];

  mkNixosConfig = host: nixpkgs.lib.nameValuePair host (
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./${host}.nix ];
    }
  );
in
self.lib.mapListToAttrs mkNixosConfig hosts
