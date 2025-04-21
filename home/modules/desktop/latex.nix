# Config of LaTeX ecosystem

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.desktop.latex;
in
{
  options.my.desktop.latex.enable = lib.mkEnableOption "latex";

  config = lib.mkIf cfg.enable {
    my.desktop.zathura.enable = lib.mkForce true;

    home.packages = [
      pkgs.tectonic
      pkgs.texlive.combined.scheme-full
    ];
  };
}
