{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = false;
  };

  home.stateVersion = "23.11";
}
