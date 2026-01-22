{ self, inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./android-integration.nix
  ];
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
    nano
    # openvscode-server
    # Some common stuff that people expect to have
    #gitFull
    #coreutils
    toybox
    which
    diffutils
    findutils
    util-linux
    tzdata
    man
    gnugrep
    gnupg
    gnused
    bzip2
    gzip
    xz
    zip
    unzip
    tldr
    opensshWithKerberos
    screen
    code-server
    git
    git-crypt
  ];

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix = {
    extraOptions = ''
       experimental-features = nix-command flakes
    '';
    registry = {
        nixpkgs = {
            from = {
                id = "nixpkgs";
                type = "indirect";
            };
            flake = inputs.nixpkgs;
        };
    };
  };

  terminal = {
    font = "${pkgs.google-fonts.override {fonts = ["SourceCodePro"];}}/share/fonts/truetype/SourceCodePro[wght].ttf";
  };
  # Set your time zone
  time.timeZone = "Europe/London";

  home-manager={
    config = self.homeManagerModules.daniel;
    backupFileExtension = "bak";
    sharedModules = [
      self.homeManagerModules.shared
      inputs.plasma-manager.homeManagerModules.plasma-manager
      {
        config = {
          args = {
            cfg = {
              install-lists = [
                #"core_utils"
              ];
            };
            isNixOS = false;
            isNixOnDroid = true;
            system = pkgs.stdenv.hostPlatform.system;
            flake = self;
          };
        };
      }
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
