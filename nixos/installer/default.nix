{ self, nixpkgs, disko, ... } @ inputs:

let
  inherit (nixpkgs) lib;

  mkInstallerShell = name: nixosConfiguration:
    let
      inherit (nixosConfiguration.pkgs.stdenv.hostPlatform) system;
      inherit (nixosConfiguration) config;

      pkgs = nixosConfiguration.pkgs.extend (final: prev: {
        inherit (disko.packages.${system}) disko;
      });

      # Only provide an installer shell to those hosts that have a disko config
      shell =
        if (! builtins.hasAttr "disko" config)
        then null
        else import ./shell.nix { inherit config pkgs inputs; };
    in
    lib.optionalAttrs (shell != null) { ${system}.${name} = shell; };
in
self.lib.recursiveMergeAttrs (
  builtins.filter
    (x: x != { })
    (lib.mapAttrsToList mkInstallerShell self.nixosConfigurations)
)
