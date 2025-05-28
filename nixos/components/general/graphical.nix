{config, pkgs, lib, ...}:

{
  imports=[
    ../specific/sddm/theming.nix
  ];

  config= lib.mkIf (config.systemConfig.graphicalEnv) {
    # Enable the X11 windowing system.
    services = {
      displayManager={
        # SDDM
        sddm={
          enable=true;
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
        excludePackages = with pkgs; [
          xterm
        ];
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

    # Remove Unnecessary Plasma Programs
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      elisa
    ];

    environment.sessionVariables = {
      # NIXOS_OZONE_WL=1; # Wayland webapps
      MOZ_ENABLE_WAYLAND=1; # Firefox Wayland
      MOZ_WEBRENDER=1;
      KWIN_DRM_ALLOW_INTEL_COLORSPACE=1;
      KWIN_FORCE_ASSUME_HDR_SUPPORT=1;
    };

    # Configure console keymap
    console.keyMap = "uk";

    programs={
      # Allowing GTK theming
      dconf.enable = true;
      # Kde connect
      kdeconnect = {
        enable=true;
        package = lib.mkForce pkgs.kdeConnect;
      };
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
        #(vaapiIntel.override {enableHybridCodec = true;})
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

    ## Onedrive now configured using rClone
    #services.onedrive.enable = true;

    ## Ports for MiraCast
    networking.firewall = {
      allowedTCPPorts = [ 17500 7236 7250 ];
      allowedUDPPorts = [ 17500 7236 7250 ];
    };

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
