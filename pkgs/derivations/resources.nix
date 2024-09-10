{stdenv}:

stdenv.mkDerivation rec {
  name = "resources";
  src = builtins.path {inherit name; path = ../../resources;};
  installPhase = ''
  mkdir -p $out/resources
  cp -rv $src/* $out/resources
  '';
  phases = ["installPhase"];
}