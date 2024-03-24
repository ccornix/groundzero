{ config, ... }:

{
  environment = {
    shellAliases = {
      nr = ''sudo nixos-rebuild --flake "$FLAKE0" '';
    };
    variables.FLAKE0 = config.my.flakeURI;
  };
}
