{ inputs, ... }:

let
  hRes = 1920;
  vRes = 1080;
in
{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    primaryDisplayResolution = { horizontal = hRes; vertical = vRes; };
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
      mode = "${builtins.toString hRes}x${builtins.toString vRes}@75Hz";
      adaptive_sync = "on";
    };
  };

  home.stateVersion = "23.11";
}
