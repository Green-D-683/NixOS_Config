{
  config, 
  pkgs,
  lib,
  ...
}:
let
  cleanup = pkgs.writeScriptBin "cleanup" ''
  sudo nix profile wipe-history
  nix store gc
  sudo nix store gc 
  sudo /run/current-system/bin/switch-to-configuration boot
  '';

in
{
  config={
    # Flake
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
        warn-dirty = false
      '';
    };

    boot = {
      # Bootloader.
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      
      # Swappiness - lower is less aggressive
      kernel.sysctl = { "vm.swappiness" = 10;};
      
      # Reading Windows Drives
      supportedFilesystems = [ "ntfs" ];

      # Using latest kernel
      kernelPackages = pkgs.linuxPackages_latest;
    };

    # Firmware
    hardware={
      enableAllFirmware=true;
      enableRedistributableFirmware=true;
    };

    # Timezone and Locale
    time.timeZone = "Europe/London";
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

    # Configure console keymap
    console.keyMap = "uk";

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      fwupd
      pciutils
      usbutils
      lshw
      man
      tldr
      nix-prefetch
      gitFull
      neofetch
      libsecret
    ] ++ [cleanup];

    ## System Upgrades
    system={
      # Auto system update
      autoUpgrade={
        enable=true;
        dates="monthly";
      };
      # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      stateVersion = "23.05";
    };
  };
}