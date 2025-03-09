{pkgs, ...}:

(with pkgs; [
  # Camera
  libsForQt5.kamoso
  # Wine - runs Windows programs
  wineWowPackages.stagingFull
  winetricks
  # K-system info
  # libsForQt5.kinfocenter
  clinfo
  glxinfo
  vulkan-tools
  wayland-utils
  direnv
  # Mouse
  # solaar
  logiops
  # Cloud Storage
  # onedrivegui
  #dropbox
  glib-networking
  # Runners
  appimage-run
  # jre_minimal
  galaxy-buds-client
  gnome-network-displays
  # More General Programs
  firefox
  widevine-cdm

  # Email
  thunderbird
  protonmail-bridge
  protonmail-bridge-gui

  spotify
  libreoffice-qt6-fresh
  zoom-us
  #vscode.fhs
  logseq

  libsecret
  pdfarranger
  slack
  pkgs.texlive.combined.scheme-full
  vlc
  firefoxpwa
  scrcpy

  # Cube
  qt6.qtquick3dphysics
  qt6.qtquick3d

  rquickshare
  audio-sharing
]) ++ (with pkgs.kdePackages; [
  kio-gdrive
  kaccounts-integration
  kaccounts-providers
  signond

  # kamoso

  kinfocenter

  plasma-browser-integration
])
