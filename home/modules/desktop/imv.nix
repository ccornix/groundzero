# Config of the imv command-line image viewer

{ config, pkgs, lib, ... }:

let
  inherit (config.my.desktop.theme) termFont topBar;
  cfg = config.my.desktop.imv;
  font = "${termFont.name}:${toString topBar.fontSize}";
in
{
  options.my.desktop.imv.enable = lib.mkEnableOption "imv";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.imv ];

    xdg = {
      enable = true;
      configFile."imv/config".text =
        let
          n = "[$imv_current_index/$imv_file_count]";
          r = "[\${imv_width}x\${imv_height}]";
          s = "[\${imv_scale}%]";
          p = "$(realpath --relative-to=. \"$imv_current_file\")";
        in
        ''
          [options]
          overlay = true
          overlay_font = ${font}
          overlay_text = ${n} ${r} ${s} ${p}
        '';
    }; # xdg
  }; # config
}
