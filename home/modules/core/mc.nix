{ pkgs, ... }:

{
  xdg = {
    enable = true;
    configFile = {
      "mc/hotlist".source = ../../.config/mc/hotlist;
    };
  };

  home.packages = [ pkgs.mc ];
}
