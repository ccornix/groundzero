{ config, ... }:

{
  home = {
    username = "hapi";
    homeDirectory = "/home/hapi";
  };

  programs.git = {
    userName = "aolasz";
    userEmail = "49680062+aolasz@users.noreply.github.com";
  };

  my.flakeURI = "${config.home.homeDirectory}/dev/groundzero";
}
