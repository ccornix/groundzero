{ inputs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    primaryDisplayResolution = { horizontal = 1920; vertical = 1200; };
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
      # FIXME: does not work with Asus PA248QV
      # adaptive_sync = "on";
    };
  };

  home.stateVersion = "23.11";
}
