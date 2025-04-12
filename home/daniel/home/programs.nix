{config, lib, pkgs, ...}:
{
  ## Additional Configuration for indivudual programs
  programs = lib.mkMerge [{
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
      package = lib.mkForce pkgs.jdk;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };

    bash={
      enable = true;
      bashrcExtra = ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      '';
    };

    fish.enable = false;
    }

    (lib.mkIf (builtins.elem "core_gui" config.userModule.install-lists) {
    firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
        pkgs.firefoxpwa
      ];
    };
    thunderbird = {
      enable = true;
      profiles = {};
    };
    })

    (lib.mkIf (builtins.elem "devkit" config.userModule.install-lists) {
    vscode = {
      enable = true;
      package = pkgs.vscode; # vscode.fhs # has no sudo
    };
    })

    (lib.mkIf (builtins.elem "core_gui" config.userModule.install-lists) {
    okular = {
      enable = true;
      general = {
        obeyDrm = false;
      };
    };})
  ];
}