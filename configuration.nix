# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, config, ... }:


{

  environment.systemPackages = with pkgs; [
    fastfetch
    tree
    p7zip
    btop
    vim
    nmap
    git

    # Script Dependencies
    fzf
    jq
    screen

    # Language Servers
    bash-language-server
    cppcheck
    glsl_analyzer
    libclang
    marksman
    neocmakelsp
    nil
    vscode-json-languageserver

    prettier
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



  nix.settings.experimental-features = [ "nix-command" ];
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
