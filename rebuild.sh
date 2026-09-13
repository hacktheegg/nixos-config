#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

SNAPSHOT_DIR="/.snapshots"
STATE_FILE="${SCRIPT_DIR}/.last-rebuild"

# ---------------------------------------------------------------------------
# Select configuration
# ---------------------------------------------------------------------------

cd "$SCRIPT_DIR"

NIX_FILE=$( find "$SCRIPT_DIR" -maxdepth 1 -type f -name '*.nix' -printf '%f\n' | fzf )
[[ -n "$NIX_FILE" ]] || exit 0

NIX_ATTRIBUTE=$(
    nix eval --impure --json --expr "builtins.attrNames (import ${SCRIPT_DIR}/${NIX_FILE} {})" | jq -r '.[]' | fzf
)
[[ -n "$NIX_ATTRIBUTE" ]] || exit 0

NIX_REBUILD_MODE=$( printf '%s\n' switch boot build | fzf )
[[ -n "$NIX_REBUILD_MODE" ]] || exit 0

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------

cd "$SCRIPT_DIR"

if [[ -f "$STATE_FILE" ]]; then
    LAST_REBUILD_STATUS="$(cat "$STATE_FILE")"
else
    LAST_REBUILD_STATUS="success"
fi

if [[ "$LAST_REBUILD_STATUS" == "failed" ]]; then
    echo
    echo "Previous nixos-rebuild failed."
    echo "Amending the previous Git commit."
    echo

    git add -A
    git commit --amend --no-edit
else
    echo
    echo "Creating Git commit."
    echo

    git add -A
    git commit -m "NixOS configuration update"
fi

GIT_REVISION="$(git rev-parse --short HEAD)"
GIT_REVISION_FULL="$(git rev-parse HEAD)"

echo
echo "NIX_FILE:          ${NIX_FILE}"
echo "NIX_ATTRIBUTE:     ${NIX_ATTRIBUTE}"
echo "NIX_REBUILD_MODE:  ${NIX_REBUILD_MODE}"
echo "GIT_REVISION:      ${GIT_REVISION}"
echo

# ---------------------------------------------------------------------------
# Mark rebuild as pending
# ---------------------------------------------------------------------------

printf '%s\n' pending > "$STATE_FILE"

# ---------------------------------------------------------------------------
# Deploy configuration
# ---------------------------------------------------------------------------

run0 rm -rf /etc/nixos/*
run0 cp -r "$SCRIPT_DIR"/* /etc/nixos/

# ---------------------------------------------------------------------------
# NixOS rebuild
# ---------------------------------------------------------------------------

if run0 nixos-rebuild "$NIX_REBUILD_MODE" --file "/etc/nixos/${NIX_FILE}" --attr "${NIX_ATTRIBUTE}"
then
    printf '%s\n' success > "$STATE_FILE"

    echo
    echo "NixOS rebuild succeeded."
else
    printf '%s\n' failed > "$STATE_FILE"

    echo
    echo "NixOS rebuild FAILED."
    echo "The next rebuild will amend Git commit ${GIT_REVISION}."
    exit 1
fi

# ---------------------------------------------------------------------------
# Btrfs snapshot
# ---------------------------------------------------------------------------

SNAPSHOT_NAME="${GIT_REVISION}-$(date '+%Y%m%d-%H%M%S')"
SNAPSHOT_PATH="${SNAPSHOT_DIR}/${SNAPSHOT_NAME}"

echo
echo "Creating Btrfs snapshot:"
echo "  ${SNAPSHOT_PATH}"
echo

run0 mkdir -p "$SNAPSHOT_DIR"

run0 btrfs subvolume snapshot "/etc/nixos" "$SNAPSHOT_PATH"

echo
echo "Snapshot created successfully."
echo "Git revision: ${GIT_REVISION_FULL}"
echo "Snapshot:     ${SNAPSHOT_PATH}"
