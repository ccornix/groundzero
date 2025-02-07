{ inputs, ... }:

let
  hres = 1920;
  vres = 1200;
in
{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    primaryDisplayResolution = { horizontal = hres; vertical = vres; };
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
      mode = "${builtins.toString hres}x${builtins.toString vres}@75Hz";
      # FIXME: does not work with Asus PA248QV
      # adaptive_sync = "on";
    };
  };

  home.stateVersion = "23.11";
}
