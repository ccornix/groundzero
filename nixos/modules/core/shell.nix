{ ... }:

{
  environment.shellAliases = {
    nr = ''sudo nixos-rebuild --flake "$HOME/dev/groundzero"'';
  };
}
