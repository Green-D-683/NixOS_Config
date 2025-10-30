{config, lib, ...}:
{
    config = lib.mkIf (builtins.elem "rpi4" config.systemConfig.extraHardware) {
        boot.extraModprobeConfig = ''
            options cfg80211 ieee80211_regdom=GB
            options brcmfmac feature_disable=0x82000
        '';
    };
}
