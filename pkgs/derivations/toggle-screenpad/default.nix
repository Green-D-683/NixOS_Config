{pkgs, lib, ...}:
lib.pkgScript rec {
  inherit pkgs;
  name = "toggle-screenpad";
  scriptFile = ./${name}.sh;
  runtimeDeps = with pkgs; [
    kdePackages.libkscreen
    gnused
    python3Minimal
    gnugrep
    coreutils
  ];
}