{ config, lib, ... }:
{
  options.systemConfig.servers.router =
    let
      mkEnableOption = lib.mkEnableOption;
      mkOption = lib.mkOption;
      types = lib.types;
    in
    {
      enable = mkEnableOption "Router Configurations";
      uplink = {
        enable = mkEnableOption "Router Uplink";
        interface = mkOption {
          default = null;
          type = with types; nullOr str;
          description = "Uplink Interface for Router";
        };
      };
      downstreamWired = {
        enable = mkEnableOption "Router Wired Downstream";
        interface = mkOption {
          default = null;
          type = with types; nullOr str;
          description = "Downstream Wired Interface for Router";
        };
      };
      downstreamWiFi = {
        enable = mkEnableOption "Router Wireless Downstream";
        interface = mkOption {
          default = null;
          type = with types; nullOr str;
          description = "Downstream Wireless Interface for Router";
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
    };

  config =
    let
      cfg = config.systemConfig.servers.router;
    in
    lib.mkIf (config.systemConfig.servers.enable && cfg.enable) {
      assertions = [
        {
          assertion = cfg.uplink.enable && (cfg.uplink.interface != null);
          message = "Cannot configure an uplink connection without an interface to bind to";
        }
        {
          assertion = cfg.downstreamWired.enable && (cfg.downstreamWired.interface != null);
          message = "Cannot configure a wired downstream connection without an interface to bind to";
        }
        {
          assertion = cfg.downstreamWiFi.enable && (cfg.downstreamWiFi.interface != null);
          message = "Cannot configure a wireless downstream connection without an interface to bind to";
        }
        {
          assertion = cfg.downstreamWiFi.enable && (cfg.downstreamWiFi.ssid != null);
          message = "Cannot configure a wireless downstream connection without an SSID to use";
        }
        {
          assertion = cfg.downstreamWiFi.enable && (cfg.downstreamWiFi.password != null);
          message = "Cannot configure a wireless downstream connection without a password to use";
        }
      ];

      ## Full Router - modified from the following:
      # - https://www.jjpdev.com/posts/home-router-nixos/
      # - https://francis.begyn.be/blog/nixos-home-router
      # - https://skogsbrus.xyz/building-a-router-with-nixos/
      # - https://hackmd.io/@scopatz/rJJGqLQYU

      # Enables Routing over IPv4 and IPv6
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };

      networking =
        let
          ports = [
            # DNS
            53
            # DHCP
            67

            # Avahi mDNS
            5353
            53791
          ];
        in
        {
          # Use Cloudflare DNS by default
          nameservers = [
            "1.1.1.1"
            "2606:4700:4700::1111"
          ];
          firewall = {
            enable = true;
            extraCommands = ''
              # Set up SNAT on packets going from downstream to the wider internet
              iptables -t nat -A POSTROUTING -o enp1s0u2 -j MASQUERADE

              # Accept all connections from downstream. May not be necessary
              iptables -A INPUT -i br0 -j ACCEPT
            '';
            # Open DNS and DHCP ports
            allowedUDPPorts = ports;
            allowedTCPPorts = ports;
          };

          useDHCP = false;

          networkmanager = {
            dns = "systemd-resolved";
            wifi = {
              "powersave" = false;
            };
            settings = {
              main = {
                no-auto-default = lib.lists.foldr (a: b: "${a},${b}") "" (
                  (lib.optional cfg.downstreamWired.enable cfg.downstreamWired.interface)
                  ++ (lib.optional cfg.downstreamWiFi.enable cfg.downstreamWiFi.interface)
                  ++ (lib.optional cfg.uplink.enable cfg.uplink.interface)
                );
              };
            };
            ensureProfiles.profiles = lib.mkMerge [
              {
                # Bridge to connect wired Downstream and WiFi
                br0 = {
                  connection = {
                    id = "bridge-br0";
                    type = "bridge";
                    autoconnect = "true";
                    autoconnect-priority = "2";
                    # metered = "false";
                    autoconnect-slaves = "1";
                    mdns = "2";
                    interface-name = "br0";
                  };
                  ipv4 = {
                    method = "shared";
                    address = "192.168.255.1/24";
                  };
                  bridge = {
                    multicast-snooping = "1";
                    multicast-router = "enabled";
                    vlan-filterning = "disabled";
                  };
                  ipv6 = {
                    method = "shared";
                  };
                };
              }
              (lib.mkIf cfg.downstreamWiFi.enable {
                # WiFi Access Point
                Unknown = {
                  connection = {
                    id = "Unknown";
                    type = "wifi";
                    autoconnect = "true";
                    autoconnect-priority = "1";
                    metered = "0";
                    controller = "br0";
                    interface-name = cfg.downstreamWiFi.interface;
                    mdns = "2";
                    port-type = "bridge";
                  };
                  wifi = {
                    mode = "ap";
                    ssid = cfg.downstreamWiFi.ssid;
                    hidden = "false";
                    band = "a";
                    channel = "52"; # see https://en.wikipedia.org/wiki/List_of_WLAN_channels#5_GHz_(802.11a/h/n/ac/ax/be)
                    channel-width = "80";
                    ap-isolation = "0";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-psk";
                    psk = cfg.downstreamWiFi.password;
                    group = "ccmp";
                    pairwise = "ccmp";
                    proto = "rsn";
                  };
                  bridge-port = {
                    hairpin-mode = "1";
                  };
                };
              })
              (lib.mkIf cfg.downstreamWired.enable {
                # Inbuilt Ethernet Port
                Downstream = {
                  connection = {
                    id = "Downstream";
                    type = "ethernet";
                    mdns = "2";
                    autoconnect = "true";
                    autoconnect-priority = "2";
                    controller = "br0";
                    interface-name = cfg.downstreamWired.interface;
                    port-type = "bridge";
                  };
                  bridge-port = {
                    hairpin-mode = "false";
                  };
                };
              })
              (lib.mkIf cfg.uplink.enable {
                # Uplink - 2.5Gb Sabrent USB Ethernet Adapter
                UpLink = {
                  connection = {
                    id = "UpLink";
                    type = "ethernet";
                    mdns = "0";
                    autoconnect = "true";
                    autoconnect-priority = "2";
                    interface-name = cfg.uplink.interface;
                  };
                  ipv4 = {
                    method = "auto";
                  };
                };
              })
            ];
          };
        };

      services = {
        # Set avahi interfaces
        avahi = {
          allowInterfaces = [
            "br0"
          ];
          denyInterfaces = lib.optional cfg.uplink.enable cfg.uplink.interface;
        };
      };
    };
}
