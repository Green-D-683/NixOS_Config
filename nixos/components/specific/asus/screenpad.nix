{config, pkgs, lib, inputs, ...}:
let
screenpad-driver-package = (kernelPackage: let asus-wmi-screenpad = inputs.screenpad-driver.defaultPackage.${pkgs.stdenv.hostPlatform.system}.override{kernel=kernelPackage;};
  in [
    asus-wmi-screenpad
  ]
);
in
{
  # Screenpad SDDM
  #config.services.xserver.displayManager.setupCommands="${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 3840x2160 --output ${screenpadPort} --off";
  #config.services.xserver.displayManager.setupCommands="kscreen-doctor output.${screenpadPort}.disable";
    config= lib.mkIf (builtins.elem "screenpad" config.systemConfig.extraHardware ) (let
        screenpadSetup = pkgs.writeScript "setup-screenpad" ''
            #!${pkgs.runtimeShell}
            ${pkgs.coreutils}/bin/echo "Setting up Screenpad" >&2
            ${pkgs.coreutils}/bin/chmod a+w "/sys/class/leds/$1/brightness"
            ${pkgs.coreutils}/bin/echo "Set lcd brightness permissions finished $?" >&2
            ${pkgs.coreutils}/bin/echo 0 > "/sys/class/leds/$1/brightness"
            ${pkgs.coreutils}/bin/echo "Turn off screenpad on boot finished $?" >&2
            exit 0
        '';
        screenpadSetupUdev = ''
            # rules for asus_nb_wmi devices
            # make screenpad backlight brightness write-able by everyone
            ACTION=="add", SUBSYSTEM=="leds", KERNEL=="asus::screenpad", TAG+="systemd", ENV{SYSTEMD_WANTS}+="screenpad-setup@%k.service"
        '';
        screenpadSetupService = {
            description = "Screenpad Setup";
            unitConfig = {
                DefaultDependencies = false;
                IgnoreOnIsolate=true;
                RefuseManualStop=true;
                SurviveFinalKillSignal=true;
            };
            serviceConfig = {
                Type = "oneshot";
                RemainAfterExit="yes";
                ExecStart = "${screenpadSetup} %i";
            };
        };
    in {
        services.xserver.displayManager.setupCommands=''
        screenPadOff
        '';
        environment.systemPackages = with pkgs; [
        toggle-screenpad
        ];

        boot = {
            extraModulePackages = screenpad-driver-package config.boot.kernelPackages.kernel;
            kernelModules = [
                "asus-wmi-screenpad"
            ];
            initrd = {
                systemd = {
                    storePaths = [ screenpadSetup ];
                    services."screenpad-setup@" = screenpadSetupService;
                };
                kernelModules = [
         			"asus-wmi"
         			"asus-wmi-screenpad"
          		];
                services.udev.rules = screenpadSetupUdev;
            };
        };
        services.udev.extraRules = screenpadSetupUdev;
        systemd.services = let screenpad-sleep = pkgs.writeScript "screenpad-sleep" ''
        #!${pkgs.bash}/bin/bash

        BRIGHTNESS_FILE=/sys/class/leds/asus\:\:screenpad/brightness

        if [ ! -f $BRIGHTNESS_FILE ]; then
            exit 0
        fi

        RUN_DIR="/var/run/screenpad-sleep"
        SAVE_FILE="$RUN_DIR"/brightness

        PATH="$PATH"

        RestoreBrightness() {
            if [[ -f "$SAVE_FILE" ]]; then
                BRIGHTNESS=$(cat "$SAVE_FILE")
                rm "$SAVE_FILE"
                echo "$BRIGHTNESS" > $BRIGHTNESS_FILE
            fi
        }

        case "$1" in
            hibernate)
                mkdir -p "$RUN_DIR"
                cat $BRIGHTNESS_FILE > $SAVE_FILE
                exit $?
                ;;
            resume)
                ${screenpadSetup} asus\:\:screenpad
                RestoreBrightness
                exit 0
                ;;
            *)
                exit 1
        esac
        ''; in {
            "screenpad-setup@" = screenpadSetupService;
            screenpad-resume = {
                description = "Screenpad hibernate resume actions";
                serviceConfig = {
                    Type = "oneshot";
                    ExecStart = "${screenpad-sleep} 'resume'";
                };
                after = ["systemd-suspend.service" "systemd-suspend-then-hibernate.service" "systemd-hibernate.service"];
                requiredBy = ["systemd-suspend.service" "systemd-suspend-then-hibernate.service" "systemd-hibernate.service"];
            };
            screenpad-suspend-then-hibernate = {
                description = "Screenpad hibernate actions";
                #path = [ pkgs.kbd ];
                serviceConfig = {
                    Type = "oneshot";
                    ExecStart = "${screenpad-sleep} 'hibernate'";
                };
                before = [ "systemd-suspend.service" "systemd-suspend-then-hibernate.service" "systemd-hibernate.service" ];
                requiredBy = [ "systemd-suspend.service" "systemd-suspend-then-hibernate.service" "systemd-hibernate.service" ];
            };
        };
    });
}
