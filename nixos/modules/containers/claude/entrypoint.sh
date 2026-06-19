#!/bin/bash
# Thin entrypoint: `claude shell` drops you into an interactive shell inside
# the container (e.g. to `apt-get install` something ad hoc); anything else is
# passed straight through to the `claude` binary.
set -euo pipefail

if [ "${1:-}" = "shell" ]; then
  shift
  exec bash "$@"
fi

exec claude "$@"
