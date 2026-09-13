#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"

NIX_FILE=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name '*.nix' -printf '%f\n' | fzf)
NIX_ATTRIBUTE=$(nix eval --impure --json --expr "builtins.attrNames ( import ${SCRIPT_DIR}/${NIX_FILE} {} )" | jq -r '.[]' | fzf)
NIX_REBUILD_MODE=$(printf "switch\nboot\nbuild" | fzf)

[[ -n "$NIX_ATTRIBUTE" ]] || exit 0
[[ -n "$NIX_FILE" ]] || exit 0
[[ -n "$NIX_REBUILD_MODE" ]] || exit 0

echo "NIX_FILE: ${NIX_FILE}"
echo "NIX_ATTRIBUTE: ${NIX_ATTRIBUTE}"
echo "NIX_REBUILD_MODE: ${NIX_REBUILD_MODE}"

# run0 rm -r /etc/nixos/*

# run0 cp -r "$SCRIPT_DIR"/* /etc/nixos/

# run0 nixos-rebuild "${NIX_REBUILD_MODE}" --file "/etc/nixos/${NIX_FILE}" --attr "${NIX_ATTRIBUTE}"
