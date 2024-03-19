{ config, lib, ... }:

{
  home.sessionVariables = {
    # TODO: check if needed
    # TMUX_TMPDIR = "";
  };

  # TODO: check if it works via SSH and in tty
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "xterm-256color";
    extraConfig = ''
      set -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
