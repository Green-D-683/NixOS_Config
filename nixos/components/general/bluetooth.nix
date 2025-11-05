{config, pkgs, lib, ...}:

{
  # Enable Bluetooth
    config = lib.mkIf (config.systemConfig.optimiseFor != "server") {
        hardware.bluetooth=  {
            enable = true;
            powerOnBoot = true;
            settings = {
                General = {
                    Enable = "Source,Sink,Media,Socket";
                    UserspaceHID = false;
                    #ControllerMode = "le";
                    Experimental = true;
                };
            };
            package = pkgs.bluez-experimental;
        };
        services.pipewire.wireplumber.extraConfig = {
            "10-bluez" = {
            };
        };
    };
}
