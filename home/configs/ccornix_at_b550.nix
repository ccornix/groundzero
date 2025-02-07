{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = true;
    gaming = {
      devilutionx.enable = true;
      diablo2.enable = true;
      wine.enable = true;
    };
    virtualization.enable = true;
  };
        
  wayland.windowManager.sway.config.output = {
    HDMI-A-1 = {
      adaptive_sync = "on"; 
    };
  };

  home.stateVersion = "23.11";
}
