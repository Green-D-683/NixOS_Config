{ pkgs, lib, pkgs-openlp, ... }:

let 
  install_list = map (x : ../../../pkgs/programs/${x}.nix) [
    "basic"
    "core_gui"
    "cad"
    "devkit"
    "gaming"
    "ciccu"
    "development/default"
  ];
in 
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.

  # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "23.11";

  home.packages = (builtins.concatLists (map (x : import x {inherit lib; inherit pkgs; pkgs-openlp=pkgs-openlp;}) install_list)) ++ [pkgs.home-manager];

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
  };

  services = {
    gnome-keyring={
      enable = true;
      components = [
        "secrets"
      ];
    };
  };
}