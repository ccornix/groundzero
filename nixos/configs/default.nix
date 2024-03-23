{ self, nixpkgs, ... } @ inputs:

let
  hosts = [
    "parsley"
    "sage"
    "rosemary"
    # "thyme"
    "garlic"
  ];

  mkNixosConfig = host: nixpkgs.lib.nameValuePair host (
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./${host}.nix ];
    }
  );
in
self.lib.mapListToAttrs mkNixosConfig hosts
