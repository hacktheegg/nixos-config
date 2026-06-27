{ ... }:

{

  systemd.tmpfiles.rules = [
    "d /containers/i2pd/var/lib/i2pd 0755 150 150 -"
  ];

#   networking.firewall.allowedTCPPorts = [ 45678 ];
#   networking.firewall.allowedUDPPorts = [ 45678 ];
  #networking.firewall.enable = true; ### REMOVE LATER

  containers.i2pd-container = {
    autoStart = true;
    bindMounts = {
      "i2pd" = {
        hostPath = "/containers/i2pd/var/lib/i2pd";
        isReadOnly = false;
        mountPoint = "/var/lib/i2pd";
      };
    };
    config = { ... }: {

      system.stateVersion = "25.11"; # If you don't add a state version, nix will complain at every rebuild

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

}
