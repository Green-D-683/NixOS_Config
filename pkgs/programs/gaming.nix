{pkgs, ...}:

with pkgs; [
  # Steam
  steam
  steam-run
  heroic
  (prismlauncher.override { jdks = [ pkgs.temurin-bin-21 pkgs.temurin-bin-8 pkgs.temurin-bin-17 ]; })
  superTuxKart
]