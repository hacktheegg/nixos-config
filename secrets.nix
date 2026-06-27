let
    rootUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII3ntf94lhHmMtWHqrw1RuYSu716CIkstwjILZoLItDV root@Thinkpad-T460";
in
{
    "./Secrets/copyparty-hacktheegg.age".publicKeys = [ rootUser ];
    "./Secrets/forgejo-token.age".publicKeys = [ rootUser ];
    "./Secrets/restic-repo-password.age".publicKeys = [ rootUser ];
    "./Secrets/restic-env.age".publicKeys = [ rootUser ];
    "./Secrets/nixos-update-check-env.age".publicKeys = [ rootUser ];
}

