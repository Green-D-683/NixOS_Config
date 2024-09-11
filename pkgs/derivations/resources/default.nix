{pkgs, ...}:
let lib = pkgs.lib;
in
pkgs.stdenv.mkDerivation rec {
  name = "resources";
  src = lib.fileset.toSource {root = ./resources; fileset = lib.fileset.unions [./resources/.];};
  installPhase = ''
  mkdir -p $out/share/${name}
  cp -rv $src/* $out/share/${name}
  '';
  phases = ["installPhase"];
}