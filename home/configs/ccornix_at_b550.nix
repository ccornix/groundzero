{ inputs, pkgs, lib, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = true;
    gaming = {
      devilutionx.enable = true;
      diablo2.enable = true;
    };
    virtualization.enable = true;
  };

  home.stateVersion = "23.11";
}
