{pkgs, ...}:

(with pkgs; [
  # SDDM theme
  (pkgs.callPackage ../derivations/Win10-Breeze-SDDM.nix {}).Win10-Breeze-SDDM
  # Kaccounts
  # plasma5Packages.kio-gdrive
  # libsForQt5.kaccounts-integration
  # libsForQt5.kaccounts-providers

  # Viewing SDDM in settings
  # libsForQt5.sddm
  # libsForQt5.sddm-kcm
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
  dropbox
  glib-networking
  # Runners
  appimage-run
  # jre_minimal
  # More General Programs
  firefox
  # libsForQt5.plasma-browser-integration
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