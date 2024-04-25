{pkgs, lib, ...}:

let pyLibs = ps: with ps; [
  pip
  # (sqlalchemy-migrate.override{
  #   sqlalchemy=sqlalchemy_1_4;
  # })
  matplotlib
  numpy
  nltk
  dill
  pygame
  # (jupyter.overrideAttrs(final: prev: {
  #   propagatedBuildInputs = prev.propagatedBuildInputs ++ [pkgs.stdenv.cc.cc.lib];
  # }))
  # tkinter
  # requests
  # (
  #   buildPythonPackage rec {
  #     pname = "guizero";
  #     version = "1.4.0";
  #     src = fetchPypi {
  #       inherit pname version;
  #       sha256 = "sha256-V2TjijsqCJcS7B51NAv4M16nch43342QIc3Qr7i1eic=";
  #     };
  #     doCheck = false;
  #     propagatedBuildInputs = [
  #       ## Specify dependencies
  #       # pkgs.python3Packages.tkinter
  #       # pkgs.python3Full
  #     ];
  #   }
  # )
  # (
  #   buildPythonPackage rec {
  #     pname = "ucamcl";
  #     version = "1.0.11";
  #     src = fetchPypi {
  #       inherit pname version;
  #       sha256 = "sha256-o71UqM1HCCkSu9P7x0+gJO79FidGc3jgPacc2Gyptwg=";
  #     };
  #     doCheck = false;
  #     propagatedNativeBuildInputs = [
  #       ## Specify dependencies
  #       # pkgs.python3Packages.tkinter
  #       pkgs.python3Packages.requests
  #       pkgs.python3Packages.cryptography

  #     ];
  #   }
  # )
  # pandas
];
in
with pkgs; [# Python
  # (lib.hiPrio python3Full)
  (lib.hiPrio (python3Full.withPackages pyLibs))#.override (args: { ignoreCollisions = true; }))
  # jupyter
  libstdcxx5
]