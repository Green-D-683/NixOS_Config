{ stdenv, fetchFromGitHub }:
{
  Win10-Breeze-SDDM = stdenv.mkDerivation rec {
    pname = "Win10-Breeze-SDDM";
    version = "0.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/Win10-Breeze-SDDM
    '';
    src = fetchFromGitHub {
      owner = "Green-D-683";
      repo = "Win10-Breeze-SDDM";
      rev = "v${version}";
      sha256 = "8YeNT8S0vPb+nX6xBKSOQlJqA2sJM+p1dknXimwx4PY=";
    };
  };
}