#!/usr/bin/env bash

set -e


# git log --oneline -n 1 $( echo "HP-Mini" ) | awk -F ' ' '{print $1}'
# git log --oneline -n 1 $( hostname ) | awk -F ' ' '{print $1}'


# --- Default Variables ---
SKIP_VALIDATION=false
SKIP_GIT=false

# --- Help Menu ---
show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --skip-validation    Skip the Nix configuration validation step."
    echo "  --skip-git           Skip git checking, committing, pulling, and pushing."
    echo "  -h, --help           Show this help message."
    exit 0
}

# --- Parse Arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-validation)
            SKIP_VALIDATION=true
            shift
            ;;
        --skip-git)
            SKIP_GIT=true
            shift
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



SCRIPT_DIR=$( dirname "$( readlink -f "$0" )" )
cd "$SCRIPT_DIR/.."
SOURCE_DIR=$( pwd )
TARGET_DIR="/etc/nixos"

if [ "$SKIP_VALIDATION" = false ]; then
	echo "-- Validating Config --"
	nixos-rebuild build --file ./system.nix --attr Thinkpad-T460
else
    echo "-- Skipping Validation --"
fi


if [ "$SKIP_GIT" = false ]; then
	if [[ -n $( git status --porcelain ) ]] ; then
		echo "-- Changes Made --"
		git status -s
		echo ""

		read -r -p "Commit Message: " COMMIT_MSG

		if [[ -z "$COMMIT_MSG" ]] ; then
			echo "-- ERROR: Commit Message Required --"
			exit 1
		fi

		git add .
		git commit -m "$COMMIT_MSG"
	else
		echo "-- No Changes Found. Continuing --"
	fi
else
    echo "-- Skipping Git Operations --"
fi


echo "-- Updating Syncing System Config --"
run0 git -C "$TARGET_DIR" pull "${SOURCE_DIR}" "main"


echo "-- Running Rebuild --"
run0 nixos-rebuild switch

if [ "$SKIP_GIT" = false ]; then
	echo "-- Updating Remote --"
	git push origin main
fi


echo "-- Complete --"
