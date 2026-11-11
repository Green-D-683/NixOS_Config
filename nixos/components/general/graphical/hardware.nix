{
    config,
    pkgs,
    lib,
    ...
}: {
    options = let
        mkEnableOption = lib.mkEnableOption;
    in {
        systemConfig = {
            niceties = {
                enableOBSCam = mkEnableOption "Enable OBS Virtual Camera";
            };
        };
    };
    config = lib.mkMerge [
        (lib.mkIf (config.systemConfig.graphicalEnv && config.systemConfig.niceties.enableOBSCam) {
            boot = {
                kernelModules = [
                    "v4l2loopback"
                ];
                extraModulePackages = with config.boot.kernelPackages; [
                    v4l2loopback
                ];

                extraModprobeConfig = ''
                    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
                '';
            };
        })
        (lib.mkIf (config.systemConfig.graphicalEnv) {
            # Enable hardware accelleration
            hardware.graphics = {
                enable = true;
                #driSupport=true;
                enable32Bit = true;
                #setLdLibraryPath = true;
                extraPackages = with pkgs; [
                    intel-media-driver
                    libva-vdpau-driver
                    libvdpau-va-gl
                ];
            };
            # Enable the X11 windowing system.

            #hardware.logitech.wireless = {
            # enable=true;
            # enableGraphical=true;
            #};
        })
    ];
}
