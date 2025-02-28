{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    primaryDisplayResolution = { horizontal = 1920; vertical = 1080; };

    desktop.enable = true;
    gaming = {
      devilutionx.enable = true;
      wine.enable = true;
    };
    virtualization.enable = true;
  };

  home.stateVersion = "24.05";
}
