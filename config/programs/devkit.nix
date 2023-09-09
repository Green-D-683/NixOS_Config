{config, pkgs, ...}:

let pyLibs = ps: with ps;[
  pip
  dill
  pygame
  tkinter
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
    # # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      vscode # Included in core.nix
      # Python
      (python3Full.withPackages pyLibs)
      jdk20
      powershell
    ];

    programs.java = { enable = true; package = pkgs.jdk20; };
  };
}