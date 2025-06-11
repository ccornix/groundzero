{ config, pkgs, lib, ... }:

let
  cfg = config.my.desktop.generic;
in
{
  options.my.desktop.generic = {
    enable = lib.mkEnableOption "generic system-level desktop settings";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        polkit_gnome # for a Policy Kit authentication agent
      ];

      # Make applications find files in <prefix>/share
      pathsToLink = [ "/share" "/libexec" ];
    };

    fonts.enableDefaultPackages = lib.mkDefault true;

    hardware.bluetooth = {
      enable = true;
      # WORKAROUND: fix bluetooth SAP (SIM Access Profile) related errors
      disabledPlugins = [ "sap" ];
    };

    security.rtkit.enable = true;

    services = {
      upower.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        wireplumber.extraConfig = {
          "thinkpad-dock-usb-audio" = {
            "monitor.alsa.rules" = [
              {
                matches = [ { "node.nick" = "ThinkPad Dock USB Audio"; } ];
                actions = {
                  "update-props" = {
                    "priority.device" = 100;
                    "priority.session" = 100;
                  };
                };
              }
            ];
          };
          "monitor-hdmi-audio-output" = {
            "monitor.alsa.rules" = [
              {
                matches = [ { "node.nick" = "PL2395W"; } ];
                actions = {
                  "update-props" = {
                    "priority.device" = 1100;
                    "priority.session" = 1100;
                  };
                };
              }
            ];
          };
        }; # wireplumber.extraConfig
      }; # pipewire
    };
  };
}
