{ ... }:

{

#   systemd.tmpfiles.rules = [
#     "d /containers/i2pd/var/lib/i2pd 0755 150 150 -"
#   ];

#   networking.firewall.allowedTCPPorts = [ 45678 ];
#   networking.firewall.allowedUDPPorts = [ 45678 ];
  #networking.firewall.enable = true; ### REMOVE LATER

  containers.i2pd-container = {
    autoStart = true;
#     bindMounts = {
#       "i2pd" = {
#         hostPath = "/containers/i2pd/var/lib/i2pd";
#         isReadOnly = false;
#         mountPoint = "/var/lib/i2pd";
#       };
#     };
    config = { ... }: {

      system.stateVersion = "23.05"; # If you don't add a state version, nix will complain at every rebuild

      # Exposing the nessecary ports in order to interact with i2p from outside the container
      networking.firewall.allowedTCPPorts = [
        7656 # default sam port
        7070 # default web interface port
        4447 # default socks proxy port
        4444 # default http proxy port
      ];

      services.i2pd = {
        enable = true;
        address = "127.0.0.1"; # you may want to set this to 0.0.0.0 if you are planning to use an ssh tunnel
        proto = {
          http.enable = true;
          socksProxy.enable = true;
          httpProxy.enable = true;
          sam.enable = true;
        };
      };
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
