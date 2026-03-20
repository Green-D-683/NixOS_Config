{pkgs, lib, ...}:
lib.pkgScript rec {
  inherit pkgs;
  name = "screenPadOff";
  scriptFile = ./${name}.sh;
  runtimeDeps = with pkgs; [
    kdePackages.libkscreen
    gnused
    gnugrep
    coreutils
    python3Minimal
  ];
}