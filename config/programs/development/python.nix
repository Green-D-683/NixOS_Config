{config, pkgs, ...}:

let pyLibs = ps: with ps;[
  pip
  dill
  pygame
  tkinter
  # jupyter
  (
    buildPythonPackage rec {
      pname = "guizero";
      version = "1.4.0";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-V2TjijsqCJcS7B51NAv4M16nch43342QIc3Qr7i1eic=";
      };
      doCheck = false;
      propagatedBuildInputs = [
        ## Specify dependencies
        # pkgs.python3Packages.tkinter
        # pkgs.python3Full
      ];
    }
  )
];
in
{
  config={
    environment.systemPackages = with pkgs; [# Python
      (python3Full.withPackages pyLibs)
    ];
  };
}