#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

SNAPSHOT_DIR="/.snapshots"

# ---------------------------------------------------------------------------
# Select configuration
# ---------------------------------------------------------------------------

cd "$SCRIPT_DIR"

NIX_FILE=$( find "$SCRIPT_DIR" -maxdepth 1 -type f -name '*.nix' -printf '%f\n' | fzf )
[[ -n "$NIX_FILE" ]] || exit 0

NIX_ATTRIBUTE=$( nix eval --impure --json --expr "builtins.attrNames (import ${SCRIPT_DIR}/${NIX_FILE} {})" | jq -r '.[]' | fzf )
[[ -n "$NIX_ATTRIBUTE" ]] || exit 0

NIX_REBUILD_MODE=$( printf '%s\n' switch boot | fzf )
[[ -n "$NIX_REBUILD_MODE" ]] || exit 0

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------

cd "$SCRIPT_DIR"

if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit
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
# Deploy configuration
# ---------------------------------------------------------------------------

run0 git -C /etc/nixos fetch "$SCRIPT_DIR" main
run0 git -C /etc/nixos reset --hard "$GIT_REVISION_FULL"

# ---------------------------------------------------------------------------
# NixOS rebuild
# ---------------------------------------------------------------------------

run0 nixos-rebuild "$NIX_REBUILD_MODE" --file "/etc/nixos/${NIX_FILE}" --attr "${NIX_ATTRIBUTE}"

# ---------------------------------------------------------------------------
# Git tag
# ---------------------------------------------------------------------------

GENERATION=$(nixos-rebuild list-generations --json | jq -er '.[0].generation')

if git tag --list "GENERATION-${GENERATION}" | grep -q .; then
    echo "ERROR: GENERATION-${GENERATION} already has a Git tag."
    exit 1
fi

git tag "GENERATION-${GENERATION}"

echo "GENERATION:        ${GENERATION}"
echo "GIT TAG:           GENERATION-${GENERATION}"

# ---------------------------------------------------------------------------
# Btrfs snapshot
# ---------------------------------------------------------------------------

SNAPSHOT_NAME="GENERATION-[${GENERATION}]-${GIT_REVISION}-$(date '+%Y%m%d-%H%M%S')"
SNAPSHOT_PATH="${SNAPSHOT_DIR}/${SNAPSHOT_NAME}"

echo
echo "Creating Btrfs snapshot:"
echo "  ${SNAPSHOT_PATH}"
echo

run0 btrfs subvolume snapshot -r "/etc/nixos" "$SNAPSHOT_PATH"

echo
echo "Snapshot created successfully."
echo "Git revision: ${GIT_REVISION_FULL}"
echo "Snapshot:     ${SNAPSHOT_PATH}"
