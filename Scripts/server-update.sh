#!/usr/bin/env bash


SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"

echo $SCRIPT_DIR


scp -i ~/agenix-recovery -P 32991 -r "$SCRIPT_DIR/../." hacktheegg@157.211.242.19:/home/hacktheegg/NEW


ssh -t -i ~/agenix-recovery -p 32991 hacktheegg@157.211.242.19 "run0 nixos-rebuild switch --attr Practice-Server --file /home/hacktheegg/NEW/system.nix"

# var1=$(nix eval --impure --json --expr "builtins.attrNames ( import ./system.nix {} )" --extra-experimental-features nix-command | jq -r '.[]' | fzf)
