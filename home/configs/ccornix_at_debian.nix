{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.self.homeModules.default ./ccornix.nix ];

  my = {
    desktop.enable = false;
  };

  home = {
    packages = [ config.nix.package ];
    sessionVariables = {
      # Prepend to PATH to take precedence over native paths
      PATH = "$HOME/.nix-profile/bin:$PATH";
    };
    # sessionPath = [ "$HOME/.nix-profile/bin" ];
    stateVersion = "23.11";
  };

  nix = {
    enable = true;
    package = pkgs.nixVersions.nix_2_19;
  };
}
