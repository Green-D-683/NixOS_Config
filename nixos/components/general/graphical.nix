{config, pkgs, lib, ...}:

{
  config={
    # Enable the X11 windowing system.
    services = {
      displayManager={
        # SDDM
        sddm={
          enable=true;
          theme="Win10-Breeze-SDDM";
          enableHidpi=true;
          package=lib.mkForce pkgs.kdePackages.sddm;
          #wayland.enable=true;
        };
        defaultSession="plasma";#"plasmawayland";
      };
      xserver={
        enable = true;
        # Configure keymap in X11
        xkb = {
          variant = "";
          layout = "gb";
        };
      };
      libinput.enable = true;
    desktopManager={
        # Enable KDE Plasma
        # plasma5.enable = true;
        plasma6={
          enable = true;
          enableQt5Integration = true;
        };
      };
    };

    # Configure console keymap
    console.keyMap = "uk";

    programs={
      # Allowing GTK theming
      dconf.enable = true;
      # Kde connect
      kdeconnect.enable=true;
      # Kde partition manager
      partition-manager.enable=true;
    };

    hardware.logitech.wireless = {
      enable=true;
      enableGraphical=true;
    };

    hardware.opengl={
      enable=true;
      driSupport=true;
      driSupport32Bit=true;
      setLdLibraryPath = true;
      extraPackages = with pkgs; [
        intel-media-driver
        (vaapiIntel.override {enableHybridCodec = true;})
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # Flatpak
    services.flatpak.enable = true;
    
    environment.systemPackages = with pkgs; [ # import ../../programs/core_gui.nix {pkgs}#
    #   # SDDM theme
      (pkgs.callPackage ../../../pkgs/derivations/Win10-Breeze-SDDM.nix {}).Win10-Breeze-SDDM
    #   # Kaccounts
    #   plasma5Packages.kio-gdrive
    #   libsForQt5.kaccounts-integration
    #   libsForQt5.kaccounts-providers
    #   # Viewing SDDM in settings
    #   libsForQt5.sddm
    #   libsForQt5.sddm-kcm
    #   # Camera
    #   libsForQt5.kamoso
    #   # Wine - runs Windows programs
    #   wineWowPackages.stagingFull
    #   winetricks
    #   # K-system info
    #   libsForQt5.kinfocenter
    #   clinfo
    #   glxinfo
    #   vulkan-tools
    #   wayland-utils
    #   direnv
    #   onedrivegui
    #   dropbox
    #   glib-networking
    #   appimage-run
    #   widevine-cdm
    ];  

    services.onedrive.enable = true;

    ## Dropbox service
    networking.firewall = {
      allowedTCPPorts = [ 17500 ];
      allowedUDPPorts = [ 17500 ];
    };

    # systemd.user.services.dropbox = {
    #   description = "Dropbox";
    #   wantedBy = [ "graphical-session.target" ];
    #   environment = {
    #     QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
    #     QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    #   };
    #   serviceConfig = {
    #     ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
    #     ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
    #     KillMode = "control-group"; # upstream recommends process
    #     Restart = "on-failure";
    #     PrivateTmp = true;
    #     ProtectSystem = "full";
    #     Nice = 10;
    #   };
    # };
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}