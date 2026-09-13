let
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXh6RiiBaXYWLo69xZS7c9d3DriJI4dVaj/fVlfNWJi nixos host key";
  recovery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3G3MXV0lULAAMHHR5vj8rOD+9mc/jAuvbbKOQ/jTrH agenix recovery";
  mwdc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+cXDNU7PAa7gxV+1iZ2+agsxEE2T9FAIOHjwrIvx+9 trmwdc@gmail.com";
  practice-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgMpcrZARBTs83Y0i5LIuniLsQvImTI3EjNqhf0BOGc root@nixos";
in
{

  "./Secrets/Tunnel-Token-Practice-Server.age".publicKeys = [
    recovery
    practice-server
  ];

}
