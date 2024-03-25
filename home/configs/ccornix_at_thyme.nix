{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = true;
    gaming = {
      devilutionx.enable = true;
    };
  };

  home.stateVersion = "23.11";
}
