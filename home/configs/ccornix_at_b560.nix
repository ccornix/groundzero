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

  wayland.windowManager.sway.config.output = {
    HDMI-A-1 = { mode = "1920x1080@50.000Hz"; };
  };

  home.stateVersion = "24.05";
}
