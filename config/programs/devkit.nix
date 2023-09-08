{config, pkgs, ...}:

let pyLibs = ps: with ps;[
  dill
  pygame
  guizero
];
in

{
  config={
    # # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      vscode # Included in core.nix
      # Python
      python3Full.withPackages pyLibs
      python310Packages.pip
      oraclejdk11
    ];
  };
}