#!/usr/bin/env bash

# Define colors for the "Spam" effect
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "!!! EMERGENCY BACKUP INITIATED !!!"

# 1. Sync Nixos Config
echo "Backing up /etc/nixos..."
# # Force a push regardless of status
cd /etc/nixos && git add . && git commit -m "EMERGENCY_BACKUP_$(date +%Y%m%d_%H%M%S)" && git push origin main
NIX_STATUS=$?

# 2. Sync Password Store
echo "Backing up Passwords..."
cd /home/password-store && git add . && git commit -m "EMERGENCY_BACKUP_$(date +%Y%m%d_%H%M%S)" && git push origin master
PASS_STATUS=$?

# 3. Restic Snapshot (with a specific tag)
echo "Running Restic emergency snapshot..."
restic backup /home/hacktheegg --tag "EMERGENCY" --host "hacktheegg-emergency"
RESTIC_STATUS=$?

# --- VALIDATION PHASE ---

if [ $NIX_STATUS -ne 0 ] || [ $PASS_STATUS -ne 0 ] || [ $RESTIC_STATUS -ne 0 ]; then
    # FAILURE SPAM
    for i in {1..50}; do
       echo -e "${RED}FAILURE: ONE OR MORE BACKUPS FAILED! SHUTDOWN ABORTED?${NC}"
       sleep 0.1
    done
    echo "Check logs immediately. Press Ctrl+C to abort poweroff, or wait 5 seconds for forced shutdown."
    sleep 5
fi

# THE NUCLEAR OPTION
# -f forces, -f -f skips the shutdown scripts and pulls the plug (virtually)
systemctl poweroff -ff
