#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"

VAR_HOSTNAME=""
NIX_HARDWARE_ROOT="/mnt"



# hostnamectl
# cat /sys/firmware/efi/fw_platform_size



show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --hostname [VALUE]      Sets the name to be used when identifying this device."
    echo "  --hardware-root [VALUE] Sets the base path that the generated hardware configuration will be based from. (default: \"/mnt\")"
    echo "  -h, --help              Show this help message."
    exit 0
}


while [[ $# -gt 0 ]]; do
    case "$1" in
        --hostname)
            if [[ -z "$2" || "$2" == -* ]] ; then
                echo "Hostname Missing or Invalid, Try Again" 1>&2
                exit 1
            fi
            VAR_HOSTNAME="$2"
            shift 2
            ;;
        --hardware-root)
            if [[ -z "$2" || "$2" == -* ]] ; then
                echo "Hardware Root Missing or Invalid, Try Again" 1>&2
                exit 1
            fi
            NIX_HARDWARE_ROOT="$2"
            shift 2
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



if [[ -z "$VAR_HOSTNAME" ]] ; then
    echo "Hardware Model: $(hostnamectl -j | jq -er '.HardwareModel')"
    read -r -p "Chosen Hostname: " VAR_HOSTNAME
fi
[[ -n "$VAR_HOSTNAME" ]] || exit 0
if [[ ! "$VAR_HOSTNAME" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
    echo "Invalid hostname: $VAR_HOSTNAME" >&2
    exit 1
fi
if (( ${#VAR_HOSTNAME} > 63 )); then
    echo "Hostname is too long" >&2
    exit 1
fi



echo "SCRIPT_DIR: ""$SCRIPT_DIR"
echo "VAR_HOSTNAME: ""$VAR_HOSTNAME"
echo "NIX_HARDWARE_ROOT: ""$NIX_HARDWARE_ROOT"



if [ ! -d "$SCRIPT_DIR""/../Hosts" ]; then
    echo "No Hosts Directory Found" 1>&2
    exit 1
fi

if [ ! -f "$SCRIPT_DIR""/../system.nix" ]; then
    echo "No system.nix Found" 1>&2
    exit 1
fi

if [ ! -f "$SCRIPT_DIR""/../hosts.nix" ]; then
    echo "No hosts.nix Found" 1>&2
    exit 1
fi

if [ -e "$SCRIPT_DIR""/../Hosts/""$VAR_HOSTNAME" ]; then
    echo "Host Already Exists" 1>&2
    exit 1
fi



mkdir "$SCRIPT_DIR""/../Hosts/""$VAR_HOSTNAME"
# echo "Creating File ""$SCRIPT_DIR""/configuration.nix"
nixos-generate-config --show-hardware-config --root "$NIX_HARDWARE_ROOT" > "$SCRIPT_DIR""/../Hosts/""$VAR_HOSTNAME""/hardware-configuration.nix"



cat > "$SCRIPT_DIR""/../Hosts/""$VAR_HOSTNAME""/default.nix" << EOF
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./../../Modules
  ];

  # omelette.boot.efi.enable = true;

  # omelette.boot.bios.enable = true;
  # omelette.boot.bios.device = "/dev/sda";

  ## SET THIS VALUE
  networking.hostName = "$VAR_HOSTNAME";

  networking.networkmanager.enable = true;

  users.users = {
    root = {
      initialPassword = "abc";
    };
  };

  time.timeZone = "Australia/NSW";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.openssh = {
    enable = true;
  };

  system.stateVersion = "25.11";
}
EOF


awk '{
    lines[NR] = $0
    if ($0 ~ /}/) last = NR
}
END {
    for (i = 1; i <= NR; i++) {
        if (i == last)
            print "'"  $VAR_HOSTNAME = ./Hosts/$VAR_HOSTNAME"';"
        print lines[i]
    }
}' "$SCRIPT_DIR""/../hosts.nix" > "$SCRIPT_DIR""/../hosts.nix.tmp"



awk -v hostname="$VAR_HOSTNAME" '
{
    lines[NR] = $0
    if ($0 ~ /}/) last = NR
}
END {
    for (i = 1; i <= NR; i++) {
        if (i == last)
            print "  " hostname " = mkSystem \"" hostname "\";"
        print lines[i]
    }
}
' "$SCRIPT_DIR""/../system.nix" > "$SCRIPT_DIR""/../system.nix.tmp"



mv -f "$SCRIPT_DIR""/../hosts.nix.tmp" "$SCRIPT_DIR""/../hosts.nix"
mv -f "$SCRIPT_DIR""/../system.nix.tmp" "$SCRIPT_DIR""/../system.nix"


