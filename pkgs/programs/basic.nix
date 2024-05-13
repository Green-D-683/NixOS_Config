{pkgs, ...}:

with pkgs; [
  fwupd
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
]