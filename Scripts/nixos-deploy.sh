#!/usr/bin/env bash

set -e


SCRIPT_DIR=$( dirname $( readlink -f "$0" ) )
cd "$SCRIPT_DIR/.."
SOURCE_DIR=$( pwd )
TARGET_DIR="/etc/nixos"


if [[ -n $( git status --porcelain ) ]] ; then
	echo "-- Changes Made --"
	git status -s
	echo ""

	read -p "Commit Message: " COMMIT_MSG

	if [[ -z "$COMMIT_MSG" ]] ; then
		echo "-- ERROR: Commit Message Required --"
		exit 1
	fi

	git add .
	git commit -m "$COMMIT_MSG"
else
	echo "-- No Changes Found. Continuing --"
fi


echo "-- Updating Syncing System Config --"
run0 git -C "$TARGET_DIR" pull "${SOURCE_DIR}" "main"


echo "-- Running Rebuild --"
run0 nixos-rebuild switch


echo "-- Updating Remote --"
git push origin main


echo "-- Complete --"
