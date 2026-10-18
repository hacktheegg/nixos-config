{
  # Pinned Nixpkgs archive
  #
  # Use `curl -I https://channels.nixos.org/nixos-26.05` to get the
  # latest commit of the stable channel and `nix-prefetch-url --unpack`
  # to compute its sha256 hash.
  nixpkgs = builtins.fetchTarball {
    url = "https://releases.nixos.org/nixos/26.05/nixos-26.05.10057.cf9d2fb3e50f/nixexprs.tar.xz";
    sha256 = "sha256:1kiwzvfgzxby7c63rfprh27c4mcgg3k0ccw9dvhvm2phcbp5a1vs";
  };
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/b027ee29d959fda4b60b57566d64c98a202e0feb.tar.gz"; # branch:main
    sha256 = "sha256:1wlpvpj45qfixdzhmk2cgiwlkyaf8a5mjy2jp5lsx2wsxblclngm";
  };
  copyparty = builtins.fetchTarball {
    url = "https://github.com/9001/copyparty/archive/aff083fb286ebeb7c9f73c157d631007536701cf.tar.gz"; # branch:hovudstraum
    sha256 = "sha256:1kxr0wnlv33pq6s06w0aiwarx7s4p7ncnnp89z80k517sairy7n1";
  };
  preservation = builtins.fetchTarball {
    url = "https://github.com/nix-community/preservation/archive/93416f4614ad2dfed5b0dcf12f27e57d27a5ab11.tar.gz"; # branch:main
    sha256 = "sha256:0im42hnghfcp0bzlkngkdd7a93fh2dm0y82sllz7ryflm4hkvhlq";
  };
  comin = builtins.fetchTarball {
    url = "https://github.com/nlewo/comin/archive/bbef55c14742d4d45ebe2b40ce4d9a220d799563.tar.gz"; # branch:main
    sha256 = "sha256:0w779cw8gxkzni6249lyn7izp9wnvc2dqlv95xdm7f6c4p418d13";
  };
}
