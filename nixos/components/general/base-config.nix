{
  config,
  pkgs,
  lib,
  system,
  ...
}:
{
  config={
    # Firmware
    hardware={
      enableRedistributableFirmware=true;
      enableAllFirmware=true;
    };

    # Swap
    zramSwap = {
      enable = true;
      priority = 5;
    };
    swapDevices = lib.optionals (config.systemConfig.swapSize > 0) [
      {
        device = "/.swapfile";
        size = lib.mkDefault (config.systemConfig.swapSize * 1024); # Size given in GiB
        priority = 4;
      }
    ];
    security.protectKernelImage = false;

    # PowerManagement
    powerManagement = {
      enable = true;
      scsiLinkPolicy = "max_performance";
      powertop.enable = false; # This messes with usb, keep it off
      cpuFreqGovernor = "ondemand";
    };
    # suspend to RAM (deep) rather than `s2idle`
    boot.kernelParams = [ "mem_sleep_default=deep" ];
    # suspend-then-hibernate
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=30m
      SuspendState=mem
    '';
    systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

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

    # Configure console
    console = {
      keyMap = "uk";
      earlySetup = true;
      packages = with pkgs; [ terminus_font ];
      font = "ter-u28n";
    };

    services.kmscon = { # KMSCon doesn't want to actually show ttys at the moment, so disable for now
      enable=false;
      fonts = with pkgs; [{name = "Source Code Pro"; package = termfont;}];
      extraConfig = lib.mkDefault ''
      "font-size=24"
      '';
    };

    # Brightness Control without KDE - maybe useful at some point
    programs.light = {
      enable = false;
      brightnessKeys = {
        enable = true;
        step = 5;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        cleanup
        wget
        cryptsetup
      ];
      sessionVariables = {
        TMPDIR="/tmp";
      };
    };

    services.fwupd.enable = true;

    ## System Upgrades
    system={
      # Auto system update
      autoUpgrade={
        enable=false;
        dates="monthly";
      };
      # extraSystemBuilderCmds = ''
      #   ${pkgs.busybox}/bin/chown root:wheel /etc/nixos
      # '';
      # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      stateVersion = "23.05";
    };

    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.suspend" ||
                action.id == "org.freedesktop.login1.hibernate"
              )
            )
          {
            return polkit.Result.YES;
          }
        });
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("wheel")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
                action.id == "org.freedesktop.login1.suspend" ||
                action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
                action.id == "org.freedesktop.login1.hibernate" ||
                action.id == "org.freedesktop.login1.hibernate-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        });
      '';
    };

    systemd.services = {
        set_etc_nixos_perm = {
            enable = true;
            description = "Set /etc/nixos permissions";
            wantedBy = [ "multi-user.target" ];
            script = ''
                # Ensure /etc/nixos has the correct permissions
                chown root:wheel /etc/nixos
                chmod 774 /etc/nixos
                # Ensure /etc/nixos/NixOS_Config has the correct permissions
                if [ -d /etc/nixos/NixOS_Config ]; then
                    chown -R root:wheel /etc/nixos/NixOS_Config
                    chmod -R 774 /etc/nixos/NixOS_Config
                fi
            '';
        };
        update_config = {
            enable = true;
            description = "Update NixOS repository";
            requires = [ "set_etc_nixos_perm.service" "NetworkManager-wait-online.service" ];
            script = let
                dir = "/etc/nixos/NixOS_Config";
                gitpkg = "${pkgs.git}/bin/git";
                git = "${gitpkg} -C ${dir}";
                remote = "git@github.com:Green-D-683/NixOS_Config.git";
                in '' # TODO This will still fail if root has not previously known GitHub
                    export PATH="${pkgs.openssh}/bin:$PATH"
                    eval `ssh-agent -s`
                    ssh-add pull_key
                    if [ ! -d ${dir} ]; then
                        echo "Git repository ${dir} does not exist, cloning it."
                        ${gitpkg} clone ${remote}
                    fi
                    export BRANCH=$(${git} branch --show-current)
                    ${git} switch main
                    ${git} pull
                    ${git} switch "$BRANCH"
                '';
            serviceConfig = {
                WorkingDirectory="/etc/nixos";
            };
        };
    };
    environment.etc."nixos/pull_key" = {
        source = ./pull_key;
        mode = "0600"; # Restrict permissions to allow ssh-add
    };
  };
}
