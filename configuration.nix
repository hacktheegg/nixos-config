# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, config, ... }:

let
  deviceName = lib.strings.removeSuffix "\n" ( builtins.readFile ./Configs/hostname );
in
{

  networking.hostName = deviceName;

  imports = [
    "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"
  ] ++ (
    if deviceName == "Thinkpad-T460" then
      [ ./Builds/Thinkpad-T460.nix ]
    else if deviceName == "Minix-NEO" then
      [ ./Builds/Minix_NEO_Z83-4.nix ]
    else if deviceName == "HP-Mini" then
      [ ./Builds/HP-Mini.nix ]
    else ## MARKER ##
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
    nil
    bash-language-server
    marksman
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

  age.identityPaths = [ "/root/.ssh/id_ed25519" ];
  age.secrets.nixos-update-check-env.file = ./Secrets/nixos-update-check-env.age;

  systemd.services.nixos-update-check = {
    description = "Uses NTFY to Alert Attention Needed";
    path = [ pkgs.git pkgs.coreutils pkgs.gnugrep pkgs.ntfy-sh pkgs._9base pkgs.hostname ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/etc/nixos";
      EnvironmentFile = config.age.secrets.nixos-update-check-env.path;
    };

    script = ''
      export notifPath="$(sha1sum "${config.age.secrets.nixos-update-check-env.path}" | awk '{print $1}')"

      git config --global safe.directory /etc/nixos

      git fetch origin main
      export BEHIND_COUNT=$(git rev-list --count HEAD..origin/main)


      if [ $BEHIND_COUNT -gt 0 ] ; then
        echo "Sub Path: $notifPath"
        ntfy publish -u "$NTFY_USERNAME":"$NTFY_PASSWORD" "$NTFY_BASE_URL/$notifPath" "$(hostname) Requires Update"
      fi

    '';

    startAt = "daily";
    enable = true;
  };



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
