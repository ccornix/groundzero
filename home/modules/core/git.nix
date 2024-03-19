{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.gitlint
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      pull = { rebase = false; };
      init = { defaultBranch = "main"; };
    };
  };
}
