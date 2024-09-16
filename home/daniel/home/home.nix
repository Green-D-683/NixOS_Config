{cfg, pkgs, lib, ... }:

{
  imports = [
    ./plasma.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home={
    username = "daniel";
    homeDirectory = "/home/daniel";

    # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.

    # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
    stateVersion = "23.11";

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
      userName = "Daniel";
      userEmail = "danielgreenhome@gmail.com";
    };
    ## Java
    java = {
      enable = true;
      package = lib.mkForce pkgs.jdk22;
    };
    firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
        pkgs.firefoxpwa
      ];
    };
    vscode = {
      enable = true;
      package = pkgs.vscode; # vscode.fhs # has no sudo
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

    okular = {
      enable = true;
      general = {
        obeyDrm = false;
      };
    };
  };

  services = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };
}