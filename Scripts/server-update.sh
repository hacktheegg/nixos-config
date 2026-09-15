#!/usr/bin/env bash


SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"

echo $SCRIPT_DIR


cd $SCRIPT_DIR

git fetch origin
git push origin


# scp -i ~/agenix-recovery -P 32991 -r "$SCRIPT_DIR/../." hacktheegg@157.211.242.19:/home/hacktheegg/NEW


ssh -t -i ~/agenix-recovery -p 32991 hacktheegg@157.211.242.19 "cd /home/hacktheegg/NEW && git fetch origin && git pull origin && run0 nixos-rebuild switch --attr Practice-Server --file /home/hacktheegg/NEW/system.nix"

# var1=$(nix eval --impure --json --expr "builtins.attrNames ( import ./system.nix {} )" --extra-experimental-features nix-command | jq -r '.[]' | fzf)
