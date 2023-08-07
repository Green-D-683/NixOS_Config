# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config, 
  pkgs,
  lib,
  ...
}:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./ux535.nix
    ];

  # Flake
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swappiness - lower is less aggressive
  boot.kernel.sysctl = { "vm.swappiness" = 10;};

  # Fireware
  hardware={
    enableAllFirmware=true;
    enableRedistributableFirmware=true;
  };

  # ThermalD - prevents overheating
  services.thermald.enable = true;

  # CPU-autofrequency
  services.auto-cpufreq.enable=true;

  # Allowing reading of windows drives
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "UnknownDevice"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # SDDM
  services.xserver.displayManager={
    sddm={
      enable=true;
      theme="Win10-Breeze-SDDM";
      enableHidpi=true;
    };
    defaultSession="plasmawayland";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Logitech control
  hardware.logitech.wireless={
    enable=true;
    enableGraphical=true;
  };

  # Allowing GTK theming
  programs.dconf.enable = true;

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allowing Settings to change store
  boot.readOnlyNixStore = false;

  # needed for store VS Code auth token 
  services.gnome.gnome-keyring.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    description = "Daniel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      thunderbird
      vscode
      spotify
      libreoffice
      neofetch
      zoom-us
      steam
      freecad
      onedrive
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ## Local Overrides:
  nixpkgs.config.packageOverrides = pkgs: rec {
      local = pkgs.callPackage ./derivations.nix {};
  };

  programs = {
    # Kde connect
    kdeconnect={
      enable=true;
    };
    # Kde partition manager
    partition-manager={
      enable=true;
    };
    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
      dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
    };
  };

  ## Steam dependencies
  hardware.opengl={
    enable=true;
    driSupport=true;
    driSupport32Bit=true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
    direnv
    #toybox
    pciutils
    usbutils
    fwupd
    # Steam
    steam
    steam-run
    tldr
    plasma5Packages.kio-gdrive
    libsForQt5.kinfocenter
    libsForQt5.kaccounts-integration
    libsForQt5.kaccounts-providers
    libsForQt5.sddm
    libsForQt5.sddm-kcm
    libsForQt5.kamoso
    gitFull
    thinkfan
    tldr
    man
    local.Win10-Breeze-SDDM
    nix-prefetch
    wineWowPackages.stagingFull
    winetricks
    ];

  # Flatpak
  services.flatpak.enable = true;

  # # Automatic Garbage Collection
  # nix.gc = {
  #   automatic = true;
  #   dates = "monthly";
  #   options = "--delete-older-than 28d";
  # };
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system={
    # Auto system update
    autoUpgrade={
      enable=true;
      dates="monthly";
    };
    #copySystemConfiguration=true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.05"; # Did you read the comment?
  };
}
