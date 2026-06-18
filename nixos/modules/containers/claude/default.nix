# Provides a `claude` command that runs Claude Code inside an isolated Podman
# container. It copies both ./Containerfile and ./entrypoint.sh into the Nix
# store as the build context.
# `claude` then behaves like the real CLI: `claude` starts a session in
# the current repo, anything you'd normally pass on the command line
# still works (e.g. `claude -p "..."`, `claude --resume`), and
# `claude shell` drops you into a plain shell inside the container for
# ad hoc poking around (installing a package with sudo, running a build
# manually, etc).

{ config, pkgs, lib, ... }:

let
  cfg = config.my.containers.claude;

  # Build context, copied into the Nix store so the whole image is
  # reproducible from this directory alone. The store path's hash becomes
  # part of the image tag below, so editing the Containerfile and running
  # `nixos-rebuild switch` produces a fresh tag automatically -- the next
  # `claude` invocation rebuilds without any manual cache-busting. Old
  # tagged images are left behind; clean them up occasionally with
  # `podman image prune`.
  containerSrc = pkgs.runCommand "claude-code-container-src" { } ''
    mkdir -p "$out"
    cp ${./Containerfile} "$out/Containerfile"
    cp ${./entrypoint.sh} "$out/entrypoint.sh"
  '';

  claude = pkgs.writeShellApplication {
    name = "claude";
    runtimeInputs = [ pkgs.podman pkgs.git ];
    text = ''
      CONTAINER_SRC="${containerSrc}"
      TAG="$(basename "$CONTAINER_SRC")"
      IMAGE="localhost/claude-code-dev:$TAG"

      if ! podman image exists "$IMAGE"; then
        echo "Building $IMAGE (first run, or Containerfile changed)..." >&2
        podman build -t "$IMAGE" -f "$CONTAINER_SRC/Containerfile" "$CONTAINER_SRC"
      fi

      REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

      # Whole-home persistence: covers ~/.claude, ~/.claude.json, and
      # anything future versions add, without chasing exact file paths.
      STATE_DIR="$HOME/.local/state/claude-code-container"
      mkdir -p "$STATE_DIR"

      MOUNT_ARGS=(
        -v "$REPO_ROOT:/workspace"
        -v "$STATE_DIR:/home/dev"
      )
      if [ -f "$HOME/.gitconfig" ]; then
        MOUNT_ARGS+=(-v "$HOME/.gitconfig:/home/dev/.gitconfig:ro")
      fi

      ENV_ARGS=()
      if [ -n "''${CLAUDE_CODE_OAUTH_TOKEN:-}" ]; then
        ENV_ARGS+=(-e "CLAUDE_CODE_OAUTH_TOKEN=$CLAUDE_CODE_OAUTH_TOKEN")
      fi

      exec podman run --rm -it \
        --userns=keep-id:uid=1000,gid=1000 \
        --cap-drop=ALL \
        "''${MOUNT_ARGS[@]}" \
        "''${ENV_ARGS[@]}" \
        -w /workspace \
        "$IMAGE" "$@"
    '';
  };
in
{
  options.my.containers.claude = {
    enable = lib.mkEnableOption "Claude Code Podman container";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    environment.systemPackages = [ claude ];
  };
}
