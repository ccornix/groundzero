{ inputs, config, ... }:

let
  user = "ccornix";
  host = config.networking.hostName;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # users = builtins.mapAttrs
    #   (user: _: ../../../home/configs/${user}_at_${host}.nix)
    #   config.users.users;
    users.ccornix = ../../../home/configs/${user}_at_${host}.nix;
    extraSpecialArgs = { inherit inputs; };
  };
}
