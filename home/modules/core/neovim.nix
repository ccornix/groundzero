{ pkgs, lib, ... }:

let
  plugins = with pkgs.vimPlugins; [
    cmp-buffer
    cmp-cmdline
    cmp-nvim-lsp
    cmp-path
    cmp_luasnip
    gruvbox-nvim
    julia-vim
    lspkind-nvim
    lualine-nvim
    luasnip
    markdown-preview-nvim
    nvim-cmp
    nvim-lspconfig
    nvim-tree-lua
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    plenary-nvim
    todo-comments-nvim
    trouble-nvim
    vim-commentary
    vim-markdown
    vim-nix
    vim-obsession
    # vim-dasht
  ];

  normalizedPname = plugin:
    builtins.replaceStrings [ "." ] [ "-" ] plugin.pname;

  configFilePath = name: ../../.config/nvim/lua/configs/${name}.lua;

  mkPluginSpec = plugin: {
    inherit plugin;
    type = "lua";
    config = let name = normalizedPname plugin; in
      lib.mkIf (builtins.pathExists (configFilePath name))
        "require('configs.${name}')()";
  };

  # HACK: fix pylsp not in PATH
  pylspWrapper = pkgs.writeShellScriptBin "pylsp" ''
    nvim-python3 -c 'from pylsp.__main__ import main; main()' "$@"
  '';
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nodePackages.bash-language-server
      nil
      shellcheck

      pylspWrapper
    ];
    extraPython3Packages = ps: with ps; [
      python-lsp-server
    ];
    plugins = map mkPluginSpec plugins;
    extraLuaConfig = "require('core')";
  };

  xdg = {
    enable = true;
    configFile = {
      "nvim/lua/core.lua".source = ../../.config/nvim/lua/core.lua;
      "nvim/lua/utils.lua".source = ../../.config/nvim/lua/utils.lua;
    } // (
      lib.filterAttrs
        (n: v: builtins.pathExists v.source)
        (
          builtins.listToAttrs
            (
              map
                (
                  name: lib.nameValuePair
                    "nvim/lua/configs/${name}.lua"
                    { source = configFilePath name; }
                )
                (map normalizedPname plugins)
            )
        )
    );
  };
}
