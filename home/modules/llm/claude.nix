{ config, lib, pkgs, ... }:
let
  cfg = config.my.llm.claude;
in
{
  options.my.llm.claude = {
    enable = lib.mkEnableOption "Claude Code AI assistant with NixOS MCP server";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.claude-code
      pkgs.unstable.mcp-nixos
    ];
    # ~/.claude.json is intentionally NOT managed by Home Manager.
    # Claude Code writes its own auth tokens and settings to it at runtime,
    # so it must remain a regular writable file. Add the mcp-nixos server
    # after first login with:
    #   claude mcp add nixos mcp-nixos
  };
}
