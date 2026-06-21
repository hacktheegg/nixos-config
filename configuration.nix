# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, config, ... }:

let
  deviceName = lib.strings.removeSuffix "\n" ( builtins.readFile ./Configs/hostname );
in
{

  networking.hostName = deviceName;

  imports = (
    if deviceName == "Thinkpad-T460" then
      [ ./Builds/Thinkpad-T460.nix ]
    else if deviceName == "Minix-NEO" then
      [ ./Builds/Minix_NEO_Z83-4.nix ]
    else if deviceName == "HP-Mini" then
      [ ./Builds/HP-Mini.nix ]
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
  ];

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

#   services.ntfy-sh = {
#     settings.base-url = "https://ntfy";
#     enable = true;
#   };

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

      echo "Sub Path: $notifPath"

      if [ $BEHIND_COUNT -gt -1 ] ; then
        ntfy publish "$notifPath" "$(hostname) Requires Update"
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


  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = false;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.efiSupport = true;

  # Configure network connections interactively with nmcli or nmtui.
  #networking.networkmanager.enable = true;
  #networking.hostName = "Thinkpad-T460"; # Define your hostname.


      #General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        #Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        #FastConnectable = true;
      #};
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
  #services.blueman.enable = true;



  # Set your time zone.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.displayManager.sddm.enable = true;
  #programs.sway.enable = true;
  #programs.waybar.enable = true;
  #home-manager.users.hacktheegg.wayland.windowManager.sway = {
  #  enable = true;
    #extraConfig = "exec waybar";
  #};
  #programs.sway.extraOptions = [ "--config" "/etc/nixos/sway.conf" ];
  #environment.etc."sway/config".source = ./sway.conf;
  #environment.sessionVariables.QT_STYLE_OVERRIDE = "adwaita-dark";
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  #services.pipewire = {
  #  enable = true;
  #  pulse.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


