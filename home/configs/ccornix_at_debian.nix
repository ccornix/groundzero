{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = false;
  };

  home = {
    packages = [ config.nix.package ];
    sessionPath = [ "$HOME/.nix-profile/bin" ];
    stateVersion = "23.11";
  };

  nix = {
    enable = true;
    package = pkgs.nixVersions.nix_2_19;
  };
}
