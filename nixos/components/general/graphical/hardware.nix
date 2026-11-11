{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (config.systemConfig.graphicalEnv) {
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
    };
}
