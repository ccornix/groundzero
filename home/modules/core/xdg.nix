{ config, ... }:

{
  # Keep $HOME reasonably clean
  #
  # Move miscellaneous dotfiles and dotdirectories not obeying the XDG Base
  # Directory Specification to the respective XDG directories.

  home = {
    sessionVariables = {
      IPYTHONDIR = "${config.xdg.configHome}/ipython";
      LESSHISTFILE = "";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      PYTHONSTARTUP = "${config.xdg.configHome}/pythonrc";
      # LESSKEY = "${config.xdg.configHome}/less/keys";
      # WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "pythonrc".source = ../../.config/pythonrc;
      "npm/npmrc".source = ../../.config/npm/npmrc;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      # Point disabled directories to the home dir
      # https://freedesktop.org/wiki/Software/xdg-user-dirs/
      desktop = "${config.home.homeDirectory}/tmp";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dl";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pics";
      publicShare = "${config.home.homeDirectory}"; # disabled
      templates = "${config.home.homeDirectory}"; # disabled
      videos = "${config.home.homeDirectory}/vids";
    };
  };
}
