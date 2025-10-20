{pkgs, ...}:

with pkgs; [
  fwupd
  nano
  pciutils
  usbutils
  lshw
  man
  tldr
  nix-prefetch
  # gitFull
  fastfetch
  libsecret
  vim
  bc
  wget
  distrobox
  docker
  binutils
  parted
  git-crypt
  cryptsetup
  htop
  btop
  krb5 # Kerberos
  opensshWithKerberos
]
