{config, pkgs, ...}:

{
  config={
    # Core Applications
    environment.systemPackages= with pkgs; [
      firefox
      thunderbird
      spotify
      libreoffice
      zoom-us
      vscode
      libsecret
      pdfarranger
      slack
      jre_minimal
      pkgs.texlive.combined.scheme-full
    ];
    # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;
  };
}