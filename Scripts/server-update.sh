#!/usr/bin/env bash


SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"

echo $SCRIPT_DIR


cd $SCRIPT_DIR

./../rebuild.sh --git-only

git fetch origin
git push origin

ssh -t -i ~/agenix-recovery -p 32991 hacktheegg@157.211.242.19 "cd /home/hacktheegg/NEW && git fetch origin && git pull origin && /home/hacktheegg/NEW/rebuild.sh --config-path /home/hacktheegg/NEW/system.nix --attribute Practice-Server --mode switch"

