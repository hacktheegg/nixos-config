#!/usr/bin/env bash

set -e


VAR_REMOTE=false
VAR_HOSTNAME=false


show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --remote [VALUE]     Set remote git to fetch and push to."
    echo "  --hostname [VALUE]   Set up this device and repo with the set hostname."
    echo "  -h, --help           Show this help message."
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --remote)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --remote requires a value."
                exit 1
            fi
            VAR_REMOTE="$2"
            shift 2
            ;;
        --hostname)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "Error: --hostname requires a value."
                exit 1
            fi
            VAR_REMOTE="$2"
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



if [ "$VAR_HOSTNAME" ] ; then
    echo "${VAR_HOSTNAME}"
    # add ./Configs/hostname
    # add ./Hardware/${$VAR_HOSTNAME}
    # add ./Builds/${$VAR_HOSTNAME}
    # INJECT BELOW LINES ABOVE [ ## MARKER ## ]
    #else if deviceName == "${$VAR_HOSTNAME}" then
    #[ ./Builds/${$VAR_HOSTNAME}.nix ]
fi



if [ "${VAR_REMOTE}" ] ; then
    echo "${VAR_REMOTE}"
fi


