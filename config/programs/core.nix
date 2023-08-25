{config, pkgs, ...}:

{
  config={
    # Core Applications
    environment.systemPackages= with pkgs; [
      firefox
      thunderbird
      # Kontact and dependencies
      kontact
      libsForQt5.kmail
      libsForQt5.kmail-account-wizard
      libsForQt5.kmailtransport
      libsForQt5.kaddressbook
      libsForQt5.korganizer
      
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