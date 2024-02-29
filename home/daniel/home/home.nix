{ pkgs, lib, nixpkgs-stable, ... }:

let 
  install_list = map (x : ../../../pkgs/programs/${x}.nix) [
    "basic"
    "core_gui"
    "cad"
    "devkit"
    "gaming"
    #"ciccu"
    "development/default"
  ];
  nixpkgs = pkgs.appendOverlays [
    (self: super: {
      self.openlp = super.hello;
    })
  ];
in 
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.

  # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "23.11";

  home.packages = (builtins.concatLists (map (x : import x {inherit lib; pkgs=nixpkgs;}) install_list)) ++ [pkgs.home-manager];

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
      package = pkgs.jdk20;
    };
    firefox = {
      enable = true;
      nativeMessagingHosts = [pkgs.plasma5Packages.plasma-browser-integration];
    };
  };

  # nixpkgs={
  #   config={
  #     overlays = [
  #       (self: super: {
  #         self.openlp = super.hello;
  #       })
  #     ];#import ./../../../pkgs/overlays.nix {inherit nixpkgs-stable; pkgs = pkgs;};
  #     allowUnfree = true;
  #     allowBroken=true;
  #     permittedInsecurePackages = [
  #       "qtwebkit-5.212.0-alpha4"
  #     ];
  #     # packageOverrides = pkgs: with pkgs; rec {
  #     #   sqlalchemy-migrate = pkgs.
        
  #     #   openlp = pkgs.openlp.override()
  #     # }
  #   };
  #   overlays = [
  #     (self: super: {
  #       self.openlp = super.hello;#super.openlp.override{
  #       #   sqlalchemy = super.sqlalchemy_1_4;
  #       #   sqlalchemy-migrate = super.sqlalchemy-migrate.override{
  #       #     sqlalchemy=super.sqlalchemy_1_4;
  #       #   };
  #       # };
      
  #       # self.openlpFull = self.openlp.override {
  #       #   pdfSupport = true;
  #       #   presentationSupport = true;
  #       #   vlcSupport = true;
  #       #   gstreamerSupport = true;
  #       # };
  #     })
  #   ];
  # };
}