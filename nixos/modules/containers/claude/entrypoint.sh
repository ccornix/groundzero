#!/bin/bash
# Thin entrypoint: `claude shell` drops you into an interactive shell inside
# the container (e.g. to `apt-get install` something ad hoc); anything else is
# passed straight through to the `claude` binary.
set -euo pipefail

# First-run home seeding. The wrapper bind-mounts a persistent (initially empty)
# host directory over /home/developer, which masks the Nix profile symlinks the
# image baked into $HOME at build time -- without them `nix` is not on PATH even
# though the /nix store volume persists. Restore the snapshot taken at build time
# (see Containerfile) into the empty home so `nix` works here and in
# `claude shell`. The guard follows the symlink chain to the real binary, so it
# seeds only when the profile is actually missing: once a home is populated --
# including packages added later via `nix profile install` -- this is skipped and
# that state survives across runs.
if [ ! -e "$HOME/.nix-profile/bin/nix" ] && [ -d /nix-home-skel ]; then
  cp -a /nix-home-skel/. "$HOME/"
fi

if [ "${1:-}" = "shell" ]; then
  shift
  exec bash "$@"
fi

exec claude "$@"
