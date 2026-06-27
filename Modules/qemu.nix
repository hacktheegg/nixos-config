{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer # For occasional debugging if SSH fails
    libvirt
    snapshot

    docker-compose
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };


  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
  };
  virtualisation.podman.enable = true;

}
