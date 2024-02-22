{config, pkgs, lib, ...}:

{
  config = {
    programs.nix-ld.enable = true;

    # Sets up all the libraries to load
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      zlib
      nss
      openssl
      curl
      expat
      libstdcxx5
    ];
  };
}