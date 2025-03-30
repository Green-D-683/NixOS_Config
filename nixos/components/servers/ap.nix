{config, lib, ...}:
{
  config = lib.mkIf ((config.systemConfig.optimiseFor == "server") && (builtins.elem "ap" config.systemConfig.servers)) {
    # ## Simple AP
    # networking = {
    #   networkmanager.ensureProfiles.profiles = {
    #     Unknown = {
    #       connection = {
    #         id = "Unknown";
    #         type = "wifi";
    #         autoconnect = "true";
    #         autoconnect-priority = "1";
    #         metered = "false";
    #       };
    #       wifi = {
    #         mode = "ap";
    #         ssid = "Unknown";
    #         hidden = "false";
    #         band = "a";
    #         channel = "40";
    #         channel-width = "80";
    #         ap-isolation = "false";
    #       };
    #       wifi-security = {
    #         key-mgmt = "wpa-psk";
    #         psk = "EduroamSlow";
    #         group = "ccmp";
    #         pairwise = "ccmp";
    #         proto = "rsn";
    #       };
    #       ipv4 = {
    #         method = "shared";
    #         address = "192.168.255.1/24";
    #       };
    #     };
    #   };
    #   firewall.allowedUDPPorts = [ 53 67 ];
    # };

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

    networking = let ports = [
      # DNS
      53 
      # DHCP
      67

      # Avahi mDNS
      5353
      53791 
    ]; in{
      # Use Cloudflare DNS by default
      nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];
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
        dns = "none";
        ensureProfiles.profiles = {
          # Bridge to connect wired Downstream and WiFi
          br0 = {
            connection = {
              id = "bridge-br0";
              type = "bridge";
              autoconnect = "true";
              autoconnect-priority = "2";
              # metered = "false";
              autoconnect-slaves = "1";
              mdns = "yes";
              interface-name = "br0";
            };
            ipv4 = {
              method = "shared";
              address = "192.168.255.1/24";
            };
            bridge = {
            
            };
          };
          # WiFi Access Point
          Unknown = {
            connection = {
              id = "Unknown";
              type = "wifi";
              autoconnect = "true";
              autoconnect-priority = "1";
              metered = "false";
              controller = "br0";
              interface-name = "wlan0";
              mdns = "yes";
              port-type = "bridge";
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
            bridge-port = {
              # hairpin-mode = "yes";
              # path-cost = "2";
              # priority = "2";
            };
          };
          # Inbuilt Ethernet Port
          end0 = {
            connection = {
              id = "Downstream";
              type = "ethernet";
              mdns = "yes";
              autoconnect = "true";
              autoconnect-priority = "2";
              controller = "br0";
              interface-name = "end0";
              port-type = "bridge";
            };
            bridge-port = {
              # hairpin-mode = "yes";
              # path-cost = "1";
              # priority = "1";
            };
          };
          # Uplink - 2.5Gb Sabrent USB Ethernet Adapter
          enp1s0u2 = {
            connection = {
              id = "UpLink";
              type = "ethernet";
              mdns = "no";
              autoconnect = "true";
              autoconnect-priority = "1";
              interface-name = "enp1s0u2";
            };
            ipv4 = {
              method = "auto";
            };
          };
        };
      };

      nat = {
        enable = true;
        internalInterfaces = [ "br0" ];
        externalInterface = "enp1s0u2";
        # enableIPv6 = true;
        # internalIPv6s = [ "2001:db8::/64" ]; # TODO: Change these if deployed - examples, not for actual use 
        # externalIPv6 = "fe80::1234:5678:9abc:def0";
        # forwardPorts = [
        #   {
        #     sourcePort = 80;
        #     proto = "tcp";
        #     destination = "fe80::1234:5678:9abc:def0]:80";
        #   }
        # ];
      };
    };

    ## Kea is a DHCP server
    services = {
      # Avahi provides mDNS for local hostname->IP correspondance
      avahi = {
        enable = true;
        reflector = true;
        allowInterfaces = [
          "br0"
        ];
        denyInterfaces = [
          "enp1s0u2"
        ];
        nssmdns4 = true;
        nssmdns6 = true;
        openFirewall = true;
        ipv4 = true;
        wideArea = true;
        publishing = {
          enable = true;
          domain = true;
          addresses = true;
        };
      };
    };
  };
}