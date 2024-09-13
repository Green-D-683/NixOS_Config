{cfg, pkgs, lib, ... }:

{
  # imports = [
  #   ./plasma.nix
  # ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home={
    username = "ciccu";
    homeDirectory = "/home/ciccu";

    # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.

    # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
    stateVersion = "23.11";

    packages = (with pkgs; [
      home-manager
      openlpFull
      firefox
      vlc
      libreoffice
      zoom-us
      scrcpy
    ]) ++ (with pkgs.kdePackages; [
      signond
    ]);

    shellAliases = {
      "neofetch" = "fastfetch";
    };
  };

  ## Additional Configuration for indivudual programs
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    ## Git
    git = {
      enable = true;
    };
    firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts = with pkgs; [
        kdePackages.plasma-browser-integration
        firefoxpwa
      ];
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash={
      enable = true;
      bashrcExtra = ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      '';
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}