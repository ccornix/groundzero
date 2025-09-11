{ config, lib, ... }:

let
  cfg = config.my.desktop.pipewire;
in
{
  options.my.desktop.pipewire = {
    enable = lib.mkEnableOption "pipewire";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire = {
        # Based on:
        # https://www.reddit.com/r/pipewire/comments/yymal7/comment/lnoye0k/
        "combined-bt-sink" = {
          "context.modules" = [
            {
              "name" = "libpipewire-module-combine-stream";
              "args" = {
                "combine.mode" = "sink";
                "node.name" = "bt-broadcast";
                "node.description" = "A combined sink to all Bluetooth devices";
                "combine.latency-compensate" = false;
                "combine.props" = {
                  "audio.position" = [ "FL" "FR" ];
                };
                "stream.props" = {
                };
                "stream.rules" = [
                  {
                    matches = [
                      {
                        "node.name" = "~bluez_output.*";
                        "media.class" = "Audio/Sink";
                      }
                    ];
                    actions = { "create-stream" = {}; };
                  }
                ];
              };
            }
          ];
        };
      }; # extraConfig.pipewire

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
}
