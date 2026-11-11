{...}: {
    config = {
        # PowerManagement
        powerManagement = {
            enable = true;
            scsiLinkPolicy = "max_performance";
            powertop.enable = false; # This messes with usb, keep it off
            cpuFreqGovernor = "ondemand";
        };
    };
}
