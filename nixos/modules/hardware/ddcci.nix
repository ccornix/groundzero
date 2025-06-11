{ config, lib, ... }:

let
  cfg = config.my.hardware.ddcci;
in
{
  options.my.hardware.ddcci = {
    enable = lib.mkEnableOption "monitor control using DDC/CI via I2C";
  };

  config = lib.mkIf cfg.enable {
    hardware.i2c.enable = true;
  };
}
