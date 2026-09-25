let
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXh6RiiBaXYWLo69xZS7c9d3DriJI4dVaj/fVlfNWJi nixos host key";
  recovery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3G3MXV0lULAAMHHR5vj8rOD+9mc/jAuvbbKOQ/jTrH agenix recovery";
  practice-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgMpcrZARBTs83Y0i5LIuniLsQvImTI3EjNqhf0BOGc root@nixos";
in
{

  "./Secrets/Tunnel-Token-Practice-Server.age".publicKeys = [
    recovery
    practice-server
  ];

  "./Secrets/weston-desktop-tls.age".publicKeys = [
    recovery
    practice-server
  ];

  "./Secrets/ntfy-creds.age".publicKeys = [
    host
    recovery
    practice-server
  ];

  "./Secrets/ntfy-url.age".publicKeys = [
    host
    recovery
    practice-server
  ];

}
