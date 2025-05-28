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
  #protonmail-bridge
  #protonmail-bridge-gui

  spotify
  libreoffice-qt6-fresh
  zoom-us
  zed-editor
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

  signal-desktop

  # OBS
  (wrapOBS {
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-3d-effect
      obs-ndi
      waveform
      obs-tuna
      obs-teleport
      #obs-hyperion
      # FIXME droidcam-obs build is broken, fix is pending:
      # https://github.com/NixOS/nixpkgs/pull/382559
      # droidcam-obs
      obs-websocket
      obs-webkitgtk
      obs-vkcapture
      obs-gstreamer
      input-overlay
      obs-multi-rtmp
      obs-mute-filter
      obs-text-pthread
      obs-source-clone
      obs-shaderfilter
      obs-source-record
      obs-replay-source
      obs-livesplit-one
      obs-freeze-filter
      looking-glass-obs
      obs-vintage-filter
      obs-scale-to-sound
      obs-composite-blur
      obs-command-source
      obs-vertical-canvas
      obs-source-switcher
      obs-move-transition
      obs-gradient-source
      obs-transition-table
      obs-rgb-levels-filter
      advanced-scene-switcher
    ];
  })
]) ++ (with pkgs.kdePackages; [
  kio-gdrive
  kaccounts-integration
  kaccounts-providers
  signond

  # kamoso

  kinfocenter

  plasma-browser-integration

  keysmith
])
