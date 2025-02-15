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
    languages = {
      language-server.ruff = {
        command = "ruff";
        config.settings = {
          lineLength = 80;
          lint.select = ["E" "F" "I"];
        };
      };
      language = [
        {
          name = "python";
          language-servers = ["ruff"];
          auto-format = true;
          formatter = {
            command = "ruff";
            args = ["format" "-"];
          };
        }
      ];
    };
    extraPackages = [
      pkgs.bash-language-server
      pkgs.nil
      pkgs.ruff
    ];
  };
}
