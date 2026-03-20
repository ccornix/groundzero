{ config, ... }:

{
  home = {
    username = "ccornix";
    homeDirectory = "/home/ccornix";
  };

  programs.git.settings.user = {
    name = "ccornix";
    email = "ccornix1758@gmail.com";
  };

  my.flakeURI = "${config.home.homeDirectory}/devel/groundzero";
}
