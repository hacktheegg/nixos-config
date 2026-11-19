{
  # Pinned Nixpkgs archive
  #
  # Use `curl -I https://channels.nixos.org/nixos-26.05` to get the
  # latest commit of the stable channel and `nix-prefetch-url --unpack`
  # to compute its sha256 hash.
  nixpkgs = builtins.fetchTarball {
    url = "https://releases.nixos.org/nixos/26.05/nixos-26.05.14630.f68407657ad2/nixexprs.tar.xz";
    sha256 = "sha256:12iy4df7fkbsm9zbji29d7xhi4jpdqcsqhw11c0vbm7hcbi2kg3f";
  };
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/5e5b88a0c8e56f291a108c2fe9934054d9745b2e.tar.gz"; # branch:main
    sha256 = "sha256:1d8byckf59azwlhnnw309b4jwdsrk85nhiix6ja7j3x30r4s7lpj";
  };
  copyparty = builtins.fetchTarball {
    url = "https://github.com/9001/copyparty/archive/deb0380511737ad10b89c9ea929215d9330cf18f.tar.gz"; # branch:hovudstraum
    sha256 = "sha256:090ziqvja0vrw101rhdfhzbq0yy0rinj21q26yzw1hcmrhnxm1ml";
  };
  preservation = builtins.fetchTarball {
    url = "https://github.com/nix-community/preservation/archive/00be7f7dd1a11ae0605386f2272288de7cf33abe.tar.gz"; # branch:main
    sha256 = "sha256:07xzjh9ifwb32x36b9px95kgg3wwmkks58lwcgydfddn4fnkdw5k";
  };
  comin = builtins.fetchTarball {
    url = "https://github.com/nlewo/comin/archive/c84768279d6c8cd0cb26c2a367890f5e63776b9e.tar.gz"; # branch:main
    sha256 = "sha256:1ay36clqqp0j40rcmg70s2m9jj5i33krk6gzwihji1rp46ch8qzx";
  };
}
