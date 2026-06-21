{ ... }:

{


  services = {
    qbittorrent = {
      enable = true;
      openFirewall = true;
      serverConfig = {
        LegalNotice.Accepted = true;
      };
      extraArgs = [
        "--confirm-legal-notice"
      ];
    };
  };

}
