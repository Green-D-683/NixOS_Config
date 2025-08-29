{ config, lib, pkgs, ... }:

let
  buildTheme = { name, version, src, themeIni ? [] }:
    pkgs.stdenv.mkDerivation rec {
      pname = "sddm-theme-${name}";
      inherit version src;

      buildCommand = ''
        dir=$out/share/sddm/themes/${name}
        doc=$out/share/doc/${pname}

        mkdir -p $dir $doc
        if [ -d $src/${name} ]; then
          srcDir=$src/${name}
        else
          srcDir=$src
        fi
        cp -r $srcDir/* $dir/
        for f in $dir/{AUTHORS,COPYING,LICENSE,README,*.md,*.txt}; do
          test -f $f && mv $f $doc/
        done
        chmod 644 $dir/theme.conf

        ${lib.concatMapStringsSep "\n" (e: ''
          ${pkgs.crudini}/bin/crudini --set --inplace $dir/theme.conf "${e.section}" "${e.key}" "${e.value}"
        '') themeIni}
      '';
    };

  customTheme = builtins.isAttrs theme;

  theme = themes.astronaut-win;
  # theme = "breeze";

  themeName = if customTheme
  then theme.pkg.name
  else theme;

  packages = if customTheme
  then [ (buildTheme theme.pkg) ] ++ theme.deps
  else [];

  themes = rec {
    aerial = {
      pkg = rec {
        name = "aerial";
        version = "20240615";
        src = pkgs.fetchFromGitHub {
          owner = "3ximus";
          repo = "${name}-sddm-theme";
          rev = "92b85ec7d177683f39a2beae40cde3ce9c2b74b0";
          sha256 = lib.fakeSha256;
        };
      };
      deps = with pkgs; [ qt5.qtmultimedia ];
    };

    abstractdark = {
      pkg = rec {
        name = "abstractdark";
        version = "20161002";
        src = pkgs.fetchFromGitHub {
          owner = "3ximus";
          repo = "${name}-sddm-theme";
          rev = "e817d4b27981080cd3b398fe928619ffa16c52e7";
          sha256 = "1si141hnp4lr43q36mbl3anlx0a81r8nqlahz3n3l7zmrxb56s2y";
        };
      };
      deps = with pkgs; [];
    };

    chili = {
      pkg = rec {
        name = "chili";
        version = "0.1.5";
        src = pkgs.fetchFromGitHub {
          owner = "MarianArlt";
          repo = "sddm-${name}";
          rev = version;
          sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
        };
      };
      deps = with pkgs; [];
    };

    deepin = {
      pkg = rec {
        name = "deepin";
        version = "20180306";
        src = pkgs.fetchFromGitHub {
          owner = "Match-Yang";
          repo = "sddm-${name}";
          rev = "6d018d2cad737018bb1e673ef4464ccf6a2817e7";
          sha256 = "1ghkg6gxyik4c03y1c97s7mjvl0kyjz9bxxpwxmy0rbh1a6xwmck";
        };
      };
      deps = with pkgs; [];
    };

    simplicity = {
      pkg = rec {
        name = "simplicity";
        version = "20230303";
        src = pkgs.fetchFromGitLab {
          owner = "isseigx";
          repo = "${name}-sddm-theme";
          rev = "0365a7ddc19099a4047116a7e2dfec6207d8fd59";
          sha256 = lib.fakeSha256;
        };
      };
      deps = with pkgs; [ noto-fonts ];
    };

    solarized = {
      pkg = rec {
        name = "solarized";
        version = "20190103";
        src = pkgs.fetchFromGitHub {
          owner = "MalditoBarbudo";
          repo = "${name}_sddm_theme";
          rev = "2b5bdf1045f2a5c8b880b482840be8983ca06191";
          sha256 = "1n36i4mr5vqfsv7n3jrvsxcxxxbx73yq0dbhmd2qznncjfd5hlxr";
        };
        themeIni = [
          { section = "General"; key = "background"; value = "bars_background.png"; }
        ];
      };
      deps = with pkgs; [ font-awesome ];
    };

    sugar-dark = {
      pkg = rec {
        name = "sugar-dark";
        version = "1.2";
        src = pkgs.fetchFromGitHub {
          owner = "MarianArlt";
          repo = "sddm-${name}";
          rev = "v${version}";
          sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
        };
      };
      deps = with pkgs; [];
    };

    astronaut = {
      pkg = rec {
        name = "astronaut";
        version = "20240606";
        src = pkgs.fetchFromGitHub {
          owner = "Keyitdev";
          repo = "sddm-${name}-theme";
          rev = "48ea0a792711ac0c58cc74f7a03e2e7ba3dc2ac0";
          sha256 = "sha256-kXovz813BS+Mtbk6+nNNdnluwp/7V2e3KJLuIfiWRD0=";
        };
      };
      deps = with pkgs; [];
    };

    astronaut-win = {
      pkg = rec {
        name = "astronaut-win";
        version = "20240606";
        src = pkgs.fetchFromGitHub {
          owner = "Keyitdev";
          repo = "sddm-astronaut-theme";
          rev = "48ea0a792711ac0c58cc74f7a03e2e7ba3dc2ac0";
          sha256 = "sha256-kXovz813BS+Mtbk6+nNNdnluwp/7V2e3KJLuIfiWRD0=";
        };
        themeIni = [
          {section = "General"; key = "background"; value = "${pkgs.resources}/share/resources/lock.png";}
        ];
      };
      deps = with pkgs; [ pkgs.resources ];
    };
  };
in
{ 
  config = lib.mkIf (config.systemConfig.graphicalEnv) {
    environment.systemPackages = packages;

    services.displayManager.sddm.theme = themeName;
  };
}
