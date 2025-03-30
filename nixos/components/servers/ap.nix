{config, lib, ...}:
{
  options.systemConfig.servers.AP = let
    mkEnableOption = lib.mkEnableOption; 
    mkOption = lib.mkOption;
    types = lib.types;
  in {
    enable = mkEnableOption "Basic Wireless Access Point";
    interface = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "Wireless Interface for AP";
    };
    ssid = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "SSID for downstream WiFi connection";
    };
    password = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "Password for downstream WiFi connection";
    };
  };

  config = let cfg = config.systemConfig.servers.AP; in lib.mkIf (config.systemConfig.servers.enable && cfg.enable) {
    assertions = [
      {
        assertion = cfg.uplink.interface != null;
        message = "Cannot configure an AP without an interface to bind to";
      }
      {
        assertion = cfg.ssid != null;
        message = "Cannot configure a wireless AP without an SSID to use";
      }
      {
        assertion = cfg.password != null;
        message = "Cannot configure a wireless AP without a password to use";
      }
    ];
    ## Simple AP
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
