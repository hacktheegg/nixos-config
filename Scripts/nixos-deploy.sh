#!/usr/bin/env bash


SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"


run0 rm -r /etc/nixos/*

run0 cp -r "$SCRIPT_DIR"/../* /etc/nixos/

run0 nixos-rebuild switch -A Thinkpad-T460 --file /etc/nixos/system.nix
