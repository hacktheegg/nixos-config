#!/usr/bin/env bash



SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"

VAR_HOSTNAME=""
VAR_FORCE=""
VAR_ROOT=""
VAR_FORCE_BOOT_BIOS=""
VAR_FORCE_BOOT_UEFI=""




show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --hostname [VALUE]   Sets the name to be used when identifying this device."
    echo "  --force              Overwrites previous hostname initialisation, potentially deleting data."
    echo "  --root [VALUE]       Passes on the --root arg to generating the hardware configuration."
    echo "  --bios               Force boot method to BIOS."
    echo "  --uefi               Force boot method to UEFI/EFI."
    echo "  -h, --help           Show this help message."
    exit 0
}



while [[ $# -gt 0 ]]; do
    case "$1" in
        --hostname)
            if [[ -z "$2" || "$2" == -* ]] ; then
                echo "Hostname Missing or Invalid, Try Again" 1>&2
                exit 1
            fi
            if [[ ! "$2" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                echo "Error: Hostname can only contain alphanumeric characters, hyphens, and underscores." 1>&2
                exit 1
            fi
            VAR_HOSTNAME="$2"
            shift 2
            ;;
        --force)
            VAR_FORCE="true"
            shift 1
            echo "--force arg unimplemented"
            ;;
        --root)
            if [[ -z "$2" || "$2" == -* ]] ; then
                echo "Root Path Missing or Invalid, Try Again" 1>&2
                exit 1
            fi
            if [[ ! "$2" =~ ^[a-zA-Z0-9_-]+$ ]]; then
                echo "Error: Root Path can only expects alphanumeric characters, hyphens, and underscores. (FIX LATER)" 1>&2
                exit 1
            fi
            VAR_ROOT="$2"
            shift 2
            echo "--root arg unimplemented"
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



if [[ ! "$VAR_HOSTNAME" ]] ; then
    echo "Hostname Missing, Try Again" 1>&2
    exit 1
fi



if [ -f "$SCRIPT_DIR""/configuration.nix" ]; then
    echo "$SCRIPT_DIR""/configuration.nix already exists"
fi

if [ ! -d "$SCRIPT_DIR""/Configs" ]; then
    echo "Creating Directory ""$SCRIPT_DIR""/Configs"
    mkdir "$SCRIPT_DIR""/Configs"
fi

if [ -f "$SCRIPT_DIR""/Configs/hostname" ]; then
    echo "Hostname already detected for this configuration, aborting" 1>&2
    exit 1
fi

if [ ! -d "$SCRIPT_DIR""/Builds" ]; then
    echo "Creating Directory ""$SCRIPT_DIR""/Builds"
    mkdir "$SCRIPT_DIR""/Builds"
fi

if [ -f "$SCRIPT_DIR""/Builds/""$VAR_HOSTNAME"".nix" ]; then
    echo "Hostname Build already exists, aborting" 1>&2
    exit 1
fi

if [ ! -d "$SCRIPT_DIR""/Hardware" ]; then
    echo "Creating Directory ""$SCRIPT_DIR""/Hardware"
    mkdir "$SCRIPT_DIR""/Hardware"
fi

if [ -f "$SCRIPT_DIR""/Hardware/""$VAR_HOSTNAME"".nix" ]; then
    echo "Hostname Hardware definition already exists, aborting" 1>&2
    exit 1
fi

if [ ! -d "$SCRIPT_DIR""/Modules" ]; then
    echo "Creating Directory ""$SCRIPT_DIR""/Modules"
    mkdir "$SCRIPT_DIR""/Modules"
fi

if [ -f "$SCRIPT_DIR""/Modules/bootloader.nix" ]; then
    echo "UEFI/EFI bootloader definition already exists, skipping"
fi

if [ -f "$SCRIPT_DIR""/Modules/bootloader-bios.nix" ]; then
    echo "BIOS bootloader definition already exists, skipping"
fi






if [ ! -f "$SCRIPT_DIR""/configuration.nix" ]; then
    echo "Creating File ""$SCRIPT_DIR""/configuration.nix"
    touch "$SCRIPT_DIR""/configuration.nix"
    cat > "$SCRIPT_DIR""/configuration.nix" << 'EOF'
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, config, /*deviceName ? lib.strings.removeSuffix "\n" (builtins.readFile ./Configs/hostname),*/ ... }:

let
  deviceName = lib.strings.removeSuffix "\n" ( builtins.readFile ./Configs/hostname );
  hostConfigs = { ### MARKER ###
  };
in
{

  networking.hostName = deviceName;

  imports = [
  ] ++ (
    if false then
      throw "IF YOU SEE THIS, SOMEHOW false == true"
    else if hostConfigs ? "${deviceName}" then
      [ ( builtins.getAttr deviceName hostConfigs ) ]
    else
      throw "Device Hostname Missing or Unidentified, Please Configure"
  );


  environment.systemPackages = with pkgs; [
    fastfetch
    tree
    p7zip
    btop
    vim
    nmap
    git

    # Language Servers
    bash-language-server
    cppcheck
    glsl_analyzer
    libclang
    marksman
    neocmakelsp
    nil
    vscode-json-languageserver
  ];

  i18n.defaultLocale = "en_AU.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


  programs = {
    tmux = {
      enable = true;
      newSession = true;
      escapeTime = 0;
      extraConfig = ''
        set -g mouse on
        set -g default-terminal "tmux-256color"
        set -as terminal-features ",xterm-256color:RGB"
        set -g status-position top
      '';
    };
  };

  services.openssh.enable = true;



  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 32d --quiet";
    persistent = true;
    randomizedDelaySec = "3d";
  };
  nix.optimise = {
    automatic = true;
    dates = "daily";
    persistent = true;
    randomizedDelaySec = "240min";
  };
  nix.settings.auto-optimise-store = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
EOF
fi

if [ -f "$SCRIPT_DIR""/configuration.nix" ]; then
    echo "Attempting Device Entry Injection into ""$SCRIPT_DIR""/configuration.nix"
    sed -i "/hostConfigs = { ### MARKER ###/a \ \ \ \ \"""$VAR_HOSTNAME""\" = ./Builds/""$VAR_HOSTNAME"".nix;" "$SCRIPT_DIR""/configuration.nix"
fi

# "HP-Mini" = ./Builds/HP-Mini.nix;

if [ ! -f "$SCRIPT_DIR""/Configs/hostname" ]; then
    echo "Creating File ""$SCRIPT_DIR""/Configs/hostname"
    touch "$SCRIPT_DIR""/Configs/hostname"
    echo "$VAR_HOSTNAME" > "$SCRIPT_DIR""/Configs/hostname"
fi

if [ ! -f "$SCRIPT_DIR""/Builds/""$VAR_HOSTNAME"".nix" ]; then
    echo "Creating File ""$SCRIPT_DIR""/Builds/""$VAR_HOSTNAME"".nix"
    touch "$SCRIPT_DIR""/Builds/""$VAR_HOSTNAME"".nix"
    cat > "$SCRIPT_DIR""/Builds/""$VAR_HOSTNAME"".nix" << EOF
{ ... }:
{
  imports =
    [
      ./../Hardware/$VAR_HOSTNAME.nix
      ./../Modules/bootloader-bios.nix
    ];
  system.stateVersion = "25.11";
}
EOF
    echo "IMPLEMENT EFI/BIOS DETECTION"
fi

if [ ! -f "$SCRIPT_DIR""/Hardware/""$VAR_HOSTNAME"".nix" ]; then
    echo "Creating File ""$SCRIPT_DIR""/Hardware/""$VAR_HOSTNAME"".nix"
    touch "$SCRIPT_DIR""/Hardware/""$VAR_HOSTNAME"".nix"
    nixos-generate-config --show-hardware-config > "$SCRIPT_DIR""/Hardware/""$VAR_HOSTNAME"".nix"
    echo "IMPLEMENT SETTING --root FOR nixos-generate-config"
fi

if [ ! -f "$SCRIPT_DIR""/Modules/bootloader.nix" ]; then
    touch "$SCRIPT_DIR""/Modules/bootloader.nix"
    cat > "$SCRIPT_DIR""/Modules/bootloader.nix" << 'EOF'
{ ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      device = "nodev";
      efiSupport = true;
      enable = true;
    };
    systemd-boot.enable = false;
  };
}
EOF
fi

if [ ! -f "$SCRIPT_DIR""/Modules/bootloader-bios.nix" ]; then
    touch "$SCRIPT_DIR""/Modules/bootloader-bios.nix"
    cat > "$SCRIPT_DIR""/Modules/bootloader-bios.nix" << 'EOF'
{ ... }:
{
  boot.loader = {
    grub = {
      device = throw "YOUR DEVICE IS USING BIOS BOOT, SO CHECK YOURSELF WHAT NEEDS TO BE DONE IN ./Modules/bootloader-bios.nix";
      enable = true;
    };
    systemd-boot.enable = false;
  };
}
EOF
fi









