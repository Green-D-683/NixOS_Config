{config, lib, ...}:
{
  config = lib.mkIf ((config.systemConfig.optimiseFor == "server") && (builtins.elem "ap" config.systemConfig.servers)) {
    networking.networkmanager.ensureProfiles.profiles = {
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
    # services.create_ap = {
    #   enable = true;
    #   settings = {
    #     INTERNET_IFACE = "eth0";
    #     WIFI_IFACE = "wlo0";
    #     SSID = "Unknown";
    #     PASSPHRASE = "EduroamSlow";
    #     FREQ_BAND="5";
    #     CHANNEL="40";
        

    #   };
    # };
  };
}

## YAML to Copy
# network:
  # version: 2
  # wifis:
  #   NM-263d8c35-b595-47eb-9821-e30ddd1887bb:
  #     renderer: NetworkManager
  #     match:
  #       name: "wlan0"
  #     access-points:
  #       "Unknown":
  #         band: "5GHz"
  #         channel: 40
  #         auth:
  #           key-management: "psk"
  #           password: "EduroamSlow"
  #         mode: "ap"
  #         networkmanager:
  #           uuid: "263d8c35-b595-47eb-9821-e30ddd1887bb"
  #           name: "Hotspot"
  #           passthrough:
  #             connection.autoconnect-priority: "1"
  #             connection.timestamp: "1713312859"
  #             wifi.ap-isolation: "0"
  #             wifi-security.group: "ccmp;"
  #             wifi-security.pairwise: "ccmp;"
  #             wifi-security.proto: "rsn;"
  #             ipv6.addr-gen-mode: "default"
  #             proxy._: ""
  #     networkmanager:
  #       uuid: "263d8c35-b595-47eb-9821-e30ddd1887bb"
  #       name: "Hotspot"
