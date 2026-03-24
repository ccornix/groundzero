{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop = {
      enable = true;
      latex.enable = true;
    };
    gaming = {
      devilutionx.enable = true;
      diablo2.enable = true;
      quake3e.enable = true;
      wine.enable = true;
    };
    llm.claude.enable = true;
    virtualization.enable = true;
  };

  home.stateVersion = "25.05";
}
