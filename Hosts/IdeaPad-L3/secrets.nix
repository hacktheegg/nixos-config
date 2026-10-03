let
  host              = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgMpcrZARBTs83Y0i5LIuniLsQvImTI3EjNqhf0BOGc root@nixos";
  eggs-recovery-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3G3MXV0lULAAMHHR5vj8rOD+9mc/jAuvbbKOQ/jTrH agenix recovery";
in
{
  "./Secrets/Tunnel-Token.age".publicKeys = [ host eggs-recovery-key ];
}
