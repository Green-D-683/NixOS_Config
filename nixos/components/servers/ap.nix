{config, lib, ...}:
{
  config = lib.mkIf ((config.systemConfig.optimiseFor == "server") && (builtins.elem "ap" config.systemConfig.servers)) {
    networking = {
      networkmanager.ensureProfiles.profiles = {
        Unknown = {
          connection = {
            id = "Unknown";
            type = "wifi";
            autoconnect = "true";
            autoconnect-priority = "1";
            metered = "false";
          };
          wifi = {
            mode = "ap";
            ssid = "Unknown";
            hidden = "false";
            band = "a";
            channel = "40";
            channel-width = "80";
            ap-isolation = "false";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "EduroamSlow";
            group = "ccmp";
            pairwise = "ccmp";
            proto = "rsn";
          };
          ipv4 = {
            method = "shared";
            address = "192.168.255.1/24";
          };
        };
      };
      firewall.allowedUDPPorts = [ 53 67 ];
    };
  };
}
