let
  host              = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXh6RiiBaXYWLo69xZS7c9d3DriJI4dVaj/fVlfNWJi nixos host key";
  eggs-recovery-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3G3MXV0lULAAMHHR5vj8rOD+9mc/jAuvbbKOQ/jTrH agenix recovery";
  host-IdeaPad-L3   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgMpcrZARBTs83Y0i5LIuniLsQvImTI3EjNqhf0BOGc root@nixos";
in
{
  "./Secrets/ntfy-creds.age".publicKeys = [ host eggs-recovery-key host-IdeaPad-L3 ];
  "./Secrets/ntfy-url.age".publicKeys   = [ host eggs-recovery-key host-IdeaPad-L3 ];
}
