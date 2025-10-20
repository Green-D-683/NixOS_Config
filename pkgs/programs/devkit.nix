{pkgs, ...}:

with pkgs; [
  #vscode # Included in core.nix
  powershell
  github-desktop
  android-tools
  universal-android-debloater

  # Distrobox GUI
  boxbuddy
  distrobox

  docker

  ventoy-full
  uefitool
  flashrom
]
