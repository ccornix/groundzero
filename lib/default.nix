{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;

  recursiveMergeAttrs = attrsList:
    builtins.foldl' lib.recursiveUpdate { } attrsList;

  getHomeCfgActivationPkg = name: homeConfiguration:
    let
      inherit (homeConfiguration.pkgs.stdenv.hostPlatform) system;
    in
    { ${system}.${name} = homeConfiguration.activationPackage; };

in
{
  inherit recursiveMergeAttrs;

  mapListToAttrs = f: xs: builtins.listToAttrs (map f xs);

  filterExistingGroups = config: groups:
    builtins.filter (x: builtins.hasAttr x config.users.groups) groups;

  gatherHomeCfgActivationPkgs = homeConfigurations:
    recursiveMergeAttrs (
      lib.mapAttrsToList getHomeCfgActivationPkg homeConfigurations
    );
}
