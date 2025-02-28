{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    primaryDisplayResolution = { horizontal = 1920; vertical = 1080; };

    desktop = {
      enable = true;
      theme.termFont.size = 10;
    };
    gaming = {
      devilutionx.enable = true;
      wine.enable = true;
    };
    virtualization.enable = true;
  };

  home.stateVersion = "23.11";
}
