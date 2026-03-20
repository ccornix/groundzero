{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  upkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  # home.sessionVariables = {
  #   EDITOR = "hx";
  #   VISUAL = "hx";
  # };

  home.packages = [
    pkgs.basedpyright
    pkgs.bash-language-server
    pkgs.helix
    pkgs.nil
    upkgs.nixfmt-rfc-style
    upkgs.ruff
    upkgs.shfmt
    pkgs.texlab
  ];

  xdg.configFile."helix/config.toml".source =
    link "${config.my.flakeURI}/home/.config/helix/config.toml";

  xdg.configFile."helix/languages.toml".source =
    link "${config.my.flakeURI}/home/.config/helix/languages.toml";

  # source:
  # https://github.com/helix-editor/helix/wiki/Language-Server-Configurations#pyright--ruff
  # performance benchmarks:
  # hx -v your_file.py 2> helix.log
}
