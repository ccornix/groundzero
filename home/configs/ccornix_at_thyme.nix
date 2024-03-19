{ inputs, pkgs, lib, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = true;
  };

  home.stateVersion = "23.11";
}
