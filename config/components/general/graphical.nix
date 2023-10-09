{config, pkgs, lib, ...}:

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
      };
      desktopManager={
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
      (pkgs.callPackage ../../derivations/Win10-Breeze-SDDM.nix {}).Win10-Breeze-SDDM
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
      # Onedrive
      #(pkgs.callPackage ../../derivations/Onedriver_temp.nix {})
      dropbox
      glib-networking
    ];  

    ## Dropbox service
    networking.firewall = {
      allowedTCPPorts = [ 17500 ];
      allowedUDPPorts = [ 17500 ];
    };

    systemd.user.services.dropbox = {
      description = "Dropbox";
      wantedBy = [ "graphical-session.target" ];
      environment = {
        QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
        QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
      };
      serviceConfig = {
        ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
        ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
        KillMode = "control-group"; # upstream recommends process
        Restart = "on-failure";
        PrivateTmp = true;
        ProtectSystem = "full";
        Nice = 10;
      };
    };
  };
}