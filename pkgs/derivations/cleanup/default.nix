{pkgs, lib, ...}:
lib.pkgScript {
  inherit pkgs;
  name = "cleanup";
  scriptFile = ./cleanup.sh;
  runtimeDeps = with pkgs; [
    sudo 
    nix
  ];
}