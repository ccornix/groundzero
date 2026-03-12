{ self, nixpkgs, home-manager, claude-code-nix, ... } @ inputs:

let
  inherit (nixpkgs) lib;

  inventory = (
    lib.mapAttrsToList
      (host: config: { user = "ccornix"; inherit host; inherit (config) pkgs; })
      self.nixosConfigurations
  ) ++ [
    {
      user = "ccornix";
      host = "debian";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    }
  ];

  mkHomeConfig = { user, host, pkgs }: lib.nameValuePair "${user}@${host}" (
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
        claude-code =
          claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
      modules = [ ./${user}_at_${host}.nix ];
    }
  );
in
self.lib.mapListToAttrs mkHomeConfig inventory
