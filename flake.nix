{
  description = "Personal NixOS and Home Manager configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    wallpapers = {
      url = "github:ccornix/wallpapers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ... } @ inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      mapListToAttrs = f: xs: builtins.listToAttrs (map f xs);

      specialArgs = { inherit inputs; };

      hosts = [
        "parsley"
        "sage"
        "rosemary"
        # "thyme"
        "garlic"
      ];

      mkNixosConfig = host: nixpkgs.lib.nameValuePair host (
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./nixos/configs/${host}.nix ];
        }
      );

      mkHomeConfig = user: host: nixpkgs.lib.nameValuePair "${user}@${host}" (
        home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = specialArgs;
          inherit (self.nixosConfigurations.${host}) pkgs;
          modules = [ ./home/configs/${user}_at_${host}.nix ];
        }
      );

    in
    {
      lib = import ./lib inputs;
      overlays = import ./overlays inputs;
      nixosModules.default = import ./nixos/modules;
      nixosConfigurations = mapListToAttrs mkNixosConfig (hosts ++ "iso");
      homeModules.default = import ./home/modules;
      homeConfigurations = mapListToAttrs (mkHomeConfig "ccornix") hosts;
      devShells = import ./nixos/installer inputs;
      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
      packages = self.lib.recursiveMergeAttrs [
        (forAllSystems (import ./packages inputs))
        # HACK: add HM configs as packages to be checked by `nix flake check`
        # This hack could be removed if flake-schemas became widely accepted
        # and HM supported them
        (self.lib.gatherHomeCfgActivationPkgs self.homeConfigurations)
      ];
    };
}
