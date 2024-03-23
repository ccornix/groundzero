{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = false; # FIXME
    gaming = {
      devilutionx.enable = false; # FIXME
    };
  };

  home.stateVersion = "23.11";
}
