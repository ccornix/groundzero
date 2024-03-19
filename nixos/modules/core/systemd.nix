{ ... }:

{
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=20s
    DefaultTimeoutStopSec=10s
  '';
}
