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
      NIXOS_OZONE_WL=1; # Wayland webapps
      ELECTRON_DISABLE_GPU=1; # Disabled until https://github.com/NixOS/nixpkgs/issues/382612 fixed
      MOZ_ENABLE_WAYLAND=1; # Firefox Wayland
      MOZ_WEBRENDER=1;
      KWIN_DRM_ALLOW_INTEL_COLORSPACE=1;
      KWIN_FORCE_ASSUME_HDR_SUPPORT=1;
    };

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
        libva-vdpau-driver
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
      fontconfig.useEmbeddedBitmaps = true;
    };

    # Mount fonts in the correct place
    system.fsPackages = [ pkgs.bindfs ];

    fileSystems = let mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregated = pkgs.callPackage (
        {
          runCommand,
          gzip,
          xorg,
        }:
        runCommand "system-fonts" {
            preferLocalBuild = true;
            nativeBuildInputs = [
                gzip
                xorg.mkfontscale
                xorg.mkfontdir
            ];
        }
          ''
            mkdir -p "$out/share/fonts"
            font_regexp='.*\.\(ttf\|ttc\|otb\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
            find ${toString config.fonts.packages} -regex "$font_regexp" \
              -exec ln -sf -t "$out/share/fonts" '{}' \;
            cd "$out/share/fonts"
            gunzip -f *.gz
            mkfontscale
            mkfontdir
            cat $(find ${pkgs.xorg.fontalias}/ -name fonts.alias) >fonts.alias
          ''
      ) { };
    in {
        "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    };

      # fonts.packages = with pkgs; [
      #   noto-fonts
      #   noto-fonts-emoji
      #   noto-fonts-cjk
      # ];

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
