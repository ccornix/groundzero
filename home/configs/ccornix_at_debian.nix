{ inputs, pkgs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = false;
  };

  home.stateVersion = "23.11";

  # Explicitly specify Nix package so that the HM activation script would pick
  # that up
  # https://github.com/nix-community/home-manager/blob/fa8c16e2452bf092ac76f09ee1fb1e9f7d0796e7/modules/home-environment.nix#L695
  nix = {
    enable = true;
    package = pkgs.nixVersions.nix_2_19;
  };
}
