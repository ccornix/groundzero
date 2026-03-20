{ pkgs, ... }:

{
  home.packages = [
    pkgs.gitlint
  ];

  programs.git = {
    enable = true;
    settings = {
      pull = { rebase = false; };
      init = { defaultBranch = "main"; };
    };
  };
}
