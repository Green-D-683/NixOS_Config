{config, pkgs, ...}:

{
  config={
    # Enable the X11 windowing system.
    services.xserver={
      enable = true;
      displayManager={
        # SDDM
        sddm={
          enable=true;
          theme="Win10-Breeze-SDDM";
          enableHidpi=true;
        };
        defaultSession="plasmawayland";
        # Enable KDE Plasma
        plasma5.enable = true;
      };
      # Configure keymap in X11
      layout = "gb";
      xkbVariant = "";
      libinput.enable = true;
    };

    # Configure console keymap
    console.keyMap = "uk";

    # Allowing GTK theming
    programs={
      # Allowing GTK theming
      dconf.enable = true;
      # Kde connect
      kdeconnect.enable=true;
      # Kde partition manager
      partition-manager.enable=true;
    };

    # Flatpak
    services.flatpak.enable = true;
    
    environment.systemPackages = with pkgs; [
      # SDDM theme
      (pkgs.callPackage ../derivations/Win10-Breeze-SDDM {}).Win10-Breeze-SDDM
      # Kaccounts
      plasma5Packages.kio-gdrive
      libsForQt5.kaccounts-integration
      libsForQt5.kaccounts-providers
      # Viewing SDDM in settings
      libsForQt5.sddm
      libsForQt5.sddm-kcm
      # Camera
      libsForQt5.kamoso
      # Wine - runs Windows programs
      wineWowPackages.stagingFull
      winetricks
      # K-system info
      libsForQt5.kinfocenter
      clinfo
      glxinfo
      vulkan-tools
      wayland-utils
      direnv
    ];  
  };
}