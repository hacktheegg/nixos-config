{
  # Pinned Nixpkgs archive
  #
  # Use `curl -I https://channels.nixos.org/nixos-26.05` to get the
  # latest commit of the stable channel and `nix-prefetch-url --unpack`
  # to compute its sha256 hash.
  nixpkgs = builtins.fetchTarball {
    url = "https://releases.nixos.org/nixos/26.05/nixos-26.05.6282.2f5a153c270b/nixexprs.tar.xz";
    sha256 = "sha256:0vgdxx20mfgx5s0kazfqi2mk5y4n0d8yxlnrkqdn8n74rh0mfbgd";
  };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/d4fd24667c8cbef124bb70a20380cab75ec8474d.tar.gz"; # branch:release-26.05
    sha256 = "sha256:0qqlidc85b1km0dp2f03wdx9k37fyisnjm6cn685ab66m723c2s6";
  };
  agenix = builtins.fetchTarball {
    url = "https://github.com/ryantm/agenix/archive/b027ee29d959fda4b60b57566d64c98a202e0feb.tar.gz"; # branch:main
    sha256 = "sha256:1wlpvpj45qfixdzhmk2cgiwlkyaf8a5mjy2jp5lsx2wsxblclngm";
  };
  copyparty = builtins.fetchTarball {
    url = "https://github.com/9001/copyparty/archive/398fcf1d18d28a75a9f234765c15b777fbb6bdea.tar.gz"; # branch:hovudstraum
    sha256 = "sha256:1gr1bpshglg7h4kz6w5kiqgxj8fx0smkrvjk3wz94qw0z9z1g459";
  };
  nur = builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/214e0b7ce605f86dd8ce68f29664e2c5deb8c08b.tar.gz"; # branch:main
    sha256 = "sha256:0jbcz72syn2xlgvx7byj7r5rmjz67b7lrzwjbmgxwpc525w7ycnv";
  };

  preservation = builtins.fetchTarball {
    url = "https://github.com/nix-community/preservation/archive/93416f4614ad2dfed5b0dcf12f27e57d27a5ab11.tar.gz"; # branch:main
    sha256 = "sha256:0im42hnghfcp0bzlkngkdd7a93fh2dm0y82sllz7ryflm4hkvhlq";
  };

}
