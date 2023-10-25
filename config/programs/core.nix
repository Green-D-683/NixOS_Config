{config, pkgs, ...}:

{
  config={
    # Core Applications
    environment.systemPackages= with pkgs; [
      firefox
      betterbird
      spotify
      libreoffice
      zoom-us
      vscode
      libsecret
      pdfarranger
      slack
      jre_minimal
      pkgs.texlive.combined.scheme-basic
    ];
    # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;
  };
}