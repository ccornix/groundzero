{ config, lib, pkgs, inputs, claude-code, ... }:

let
  cfg = config.my.llm.claude;
  upkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  options.my.llm.claude = {
    enable = lib.mkEnableOption "Claude Code AI assistant with NixOS MCP server";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      claude-code        # from claude-code-nix community flake
      upkgs.mcp-nixos    # from nixpkgs-unstable
    ];

    # ~/.claude.json is intentionally NOT managed by Home Manager.
    # Claude Code writes its own auth tokens and settings to it at runtime,
    # so it must remain a regular writable file. Add the mcp-nixos server
    # after first login with:
    #   claude mcp add nixos mcp-nixos
  };
}
