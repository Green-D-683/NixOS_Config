{config, lib, pkgs, ...}:

{
  config={
    # Enable networking
    networking={
      firewall = let ports = [
        5353
        53791

        # rQuickShare 
        49999
      ]; in {
        allowedTCPPorts = ports;
        allowedUDPPorts = ports;
      };
      networkmanager={
        enable = true;
        enableStrongSwan = true;
        connectionConfig.mdns=2;
      };
      hostName = config.systemConfig.hostname;
    };
    services={
      xl2tpd.enable = true;
      strongswan.enable = true;
      strongswan.secrets = [
        "ipsec.d/ipsec.nm-l2tp.secrets"
      ];
      # Avahi implements mDNS
      avahi = {
        enable = true;
        reflector = true;
        nssmdns4 = false;
        nssmdns6 = false;
        openFirewall = true;
        ipv4 = true;
        wideArea = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
      };
      resolved.enable = true;
    };
    security.pki.certificateFiles = ["${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"];
  };
}