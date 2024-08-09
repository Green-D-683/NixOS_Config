{config, pkgs, lib, ...}:

{
  imports=[
    ../specific/sddm/theming.nix
  ];

  config={
    # Enable the X11 windowing system.
    services = {
      displayManager={
        # SDDM
        sddm={
          enable=true;
          #theme="Win10-Breeze-SDDM";
          enableHidpi=true;
          package=lib.mkForce pkgs.kdePackages.sddm;
          wayland={
            enable=true;
            compositor="kwin";
          };
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

    #hardware.logitech.wireless = {
      #enable=true;
      # enableGraphical=true;
    #};

    hardware.graphics={
      enable=true;
      #driSupport=true;
      enable32Bit=true;
      #setLdLibraryPath = true;
      extraPackages = with pkgs; [
        intel-media-driver
        (vaapiIntel.override {enableHybridCodec = true;})
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        corefonts
        whatsapp-emoji-font
        open-fonts
      ];
      fontDir.enable=true;
    };

    # Flatpak
    services.flatpak.enable = true;

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

    security.pam.services.sddm.kwallet={
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
  };
}