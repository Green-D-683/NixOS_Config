{ pkgs, ... }:
with pkgs;
[
  firefox
  widevine-cdm
  spotify
  zed-editor
]
++ (with pkgs.kdePackages; [
  kio-gdrive
  kaccounts-integration
  kaccounts-providers
  signond

  # kamoso

  kinfocenter

  plasma-browser-integration

  keysmith

  kcharselect

  # Camera
  kamoso
])
