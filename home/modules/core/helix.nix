{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor = {
        rulers = [ 80 ];
        indent-guides = {
          character = "|";
          render = true;
        };
        # TODO: uncomment in >=25.01
        # end-of-line-diagnostics = "hint";
        # inline-diagnostics = {
        #   cursor-line = "error";
        #   other-lines = "disable";
        # };
      };
    };
    extraPackages = [
      # Convenience language servers that are available even outside of
      # development shells
      pkgs.bash-language-server
      pkgs.nil
    ];
  };
}
