{ ... }:

{
  systemd.settings.Manager = {
    DefaultTimeoutStartSec = "20s";
    DefaultTimeoutStopSec = "20s";
  };
}
