{ ... }:

{

  systemd.tmpfiles.rules = [
    "d /containers/i2pd/var/lib/i2pd 0755 root root -"
  ];

  networking.firewall.allowedTCPPorts = [ 45678 ];
  networking.firewall.allowedUDPPorts = [ 45678 ];
  networking.firewall.enable = false; ### REMOVE LATER


  containers.i2pd = {
    autoStart = true;
    bindMounts = {
      "i2pd" = {
        hostPath = "/containers/i2pd/var/lib/i2pd";
        isReadOnly = false;
        mountPoint = "/var/lib/i2pd";
      };
    };
    privateNetwork = false;
    config = { ... }: {

      networking.firewall.allowedTCPPorts = [
        7656 # SAM
        7070 # Webconsole
        4447 # SOCKS proxy
        4444 # HTTP proxy
        45678
      ];
      networking.firewall.allowedUDPPorts = [ 45678 ];

      services.i2pd = {
        enable = true;
        address = "0.0.0.0";
        port = 45678;
        proto = {
          http = {
            enable = true;
            address = "127.0.0.1";
            port = 7070;
          };
          httpProxy = {
            enable = true;
            address = "127.0.0.1";
            port = 4444;
          };
          sam = {
            enable = true;
            address = "127.0.0.1";
            port = 7656;
          };
          socksProxy = {
            enable = true;
            address = "127.0.0.1";
            port = 4447;
          };
        };
      };

      system.stateVersion = "25.11";

    };
  };

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
