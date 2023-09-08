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
    ];
    # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;
  };
}