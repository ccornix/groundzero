{ ... }:

{
  imports = [
    ./colors.nix
    ./git.nix
    ./mc.nix
    ./neovim.nix
    ./nixpkgs.nix
    ./scripts.nix
    ./shell.nix
    ./ssh.nix
    ./tmux.nix
    ./utils.nix
    ./xdg.nix
  ];

  programs.home-manager.enable = true;
}
