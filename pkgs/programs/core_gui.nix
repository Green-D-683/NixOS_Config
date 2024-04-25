{pkgs, ...}:

(with pkgs; [
  # SDDM theme
  (pkgs.callPackage ../derivations/Win10-Breeze-SDDM.nix {}).Win10-Breeze-SDDM
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
  solaar
  # Cloud Storage
  onedrivegui
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
  thunderbird
  spotify
  libreoffice
  zoom-us
  vscode
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
]) ++ (with pkgs.kdePackages; [
  kio-gdrive
  kaccounts-integration
  kaccounts-providers

  sddm
  sddm-kcm

  # kamoso

  kinfocenter

  plasma-browser-integration
])
