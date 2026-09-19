#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

SNAPSHOT_DIR="/.snapshots"

NIX_CONFIG_PATH=""
NIX_ATTRIBUTE=""
NIX_REBUILD_MODE=""
VAR_GIT_ONLY=false
NIX_CONFIG_FILE=""


show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --config-path [VALUE]   Select the Nix configuration file."
    echo "  --attribute [VALUE]     Select the NixOS configuration attribute."
    echo "  --mode [VALUE]          Rebuild mode: switch or boot."
    echo "  --git-only              Commit current configuration changes and skip deployment."
    echo "  -h, --help              Show this help message."
    exit 0
}


while [[ $# -gt 0 ]]; do
    case "$1" in
        --config-path)
            if [[ $# -lt 2 || -z "${2:-}" || "${2:0:1}" == "-" ]]; then
                echo "Config Path Missing or Invalid, Try Again" >&2
                exit 1
            fi
            NIX_CONFIG_PATH="$2"
            shift 2
            ;;
        --attribute)
            if [[ $# -lt 2 || -z "${2:-}" || "${2:0:1}" == "-" ]]; then
                echo "Attribute Missing or Invalid, Try Again" >&2
                exit 1
            fi
            NIX_ATTRIBUTE="$2"
            shift 2
            ;;
        --mode)
            if [[ $# -lt 2 || -z "${2:-}" || "${2:0:1}" == "-" ]]; then
                echo "Rebuild Mode Missing or Invalid, Try Again" >&2
                exit 1
            fi
            case "$2" in
                switch|boot)
                    NIX_REBUILD_MODE="$2"
                    ;;
                *)
                    echo "Invalid rebuild mode: $2 (expected 'switch' or 'boot')" >&2
                    exit 1
                    ;;
            esac
            NIX_REBUILD_MODE="$2"
            shift 2
            ;;
        --git-only)
            VAR_GIT_ONLY=true
            shift 1
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage details."
            exit 1
            ;;
    esac
done


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
echo "NIX_CONFIG_FILE:   ${NIX_CONFIG_FILE}"
echo "NIX_CONFIG_PATH:   ${NIX_CONFIG_PATH}"
echo "NIX_ATTRIBUTE:     ${NIX_ATTRIBUTE}"
echo "NIX_REBUILD_MODE:  ${NIX_REBUILD_MODE}"
echo "GIT_REVISION:      ${GIT_REVISION}"
echo

if [[ "$VAR_GIT_ONLY" == true ]]; then
    echo "Git-only mode: stopping before deployment."
    exit 0
fi

# ---------------------------------------------------------------------------
# Select configuration
# ---------------------------------------------------------------------------

cd "$SCRIPT_DIR"

if [[ -z "$NIX_CONFIG_PATH" ]] ; then
    NIX_CONFIG_FILE=$( find "$SCRIPT_DIR" -maxdepth 1 -type f -name '*.nix' -printf '%f\n' | fzf )
    [[ -n "$NIX_CONFIG_FILE" ]] || exit 0
    NIX_CONFIG_PATH="${SCRIPT_DIR}/${NIX_CONFIG_FILE}"
else
    NIX_CONFIG_FILE="${NIX_CONFIG_PATH##*/}"
fi

if [[ -z "$NIX_ATTRIBUTE" ]] ; then
    NIX_ATTRIBUTE=$( nix eval --impure --json --expr "builtins.attrNames (import ${NIX_CONFIG_PATH} {})" | jq -r '.[]' | fzf )
    [[ -n "$NIX_ATTRIBUTE" ]] || exit 0
fi

if [[ -z "$NIX_REBUILD_MODE" ]] ; then
    NIX_REBUILD_MODE=$( printf '%s\n' switch boot | fzf )
    [[ -n "$NIX_REBUILD_MODE" ]] || exit 0
fi

# ---------------------------------------------------------------------------
# Deploy configuration
# ---------------------------------------------------------------------------

run0 git -C /etc/nixos fetch "$SCRIPT_DIR" main
run0 git -C /etc/nixos reset --hard "$GIT_REVISION_FULL"

# ---------------------------------------------------------------------------
# NixOS rebuild
# ---------------------------------------------------------------------------

run0 nixos-rebuild "$NIX_REBUILD_MODE" --file "/etc/nixos/${NIX_CONFIG_FILE}" --attr "${NIX_ATTRIBUTE}"

GENERATION=$(nixos-rebuild list-generations --json | jq -er '.[0].generation')

# ---------------------------------------------------------------------------
# Git tag
# ---------------------------------------------------------------------------

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
