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
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/ec172013fa62135f58fb58dd17ae9651e8f39727.tar.gz"; # branch:release-26.05
    sha256 = "sha256:02mrnlirg3jxqfgkv3jh8ar9hqiwhwqq9m7n5jv5hq40vjzq2s1d";
  };
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/b027ee29d959fda4b60b57566d64c98a202e0feb.tar.gz"; # branch:main
    sha256 = "sha256:1wlpvpj45qfixdzhmk2cgiwlkyaf8a5mjy2jp5lsx2wsxblclngm";
  };
  copyparty = builtins.fetchTarball {
    url = "https://github.com/9001/copyparty/archive/aff083fb286ebeb7c9f73c157d631007536701cf.tar.gz"; # branch:hovudstraum
    sha256 = "sha256:1kxr0wnlv33pq6s06w0aiwarx7s4p7ncnnp89z80k517sairy7n1";
  };
  nur = builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/b1f0c6c027075574d0cd07587cac347afdfde0b4.tar.gz"; # branch:main
    sha256 = "sha256:02haj44v8xg6z83kikjvw7w5vd4klfvhb6c8sxawgnn4byxx3d56";
  };
  preservation = builtins.fetchTarball {
    url = "https://github.com/nix-community/preservation/archive/93416f4614ad2dfed5b0dcf12f27e57d27a5ab11.tar.gz"; # branch:main
    sha256 = "sha256:0im42hnghfcp0bzlkngkdd7a93fh2dm0y82sllz7ryflm4hkvhlq";
  };

}
