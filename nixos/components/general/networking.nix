{config, lib, pkgs, ...}:

{
  config={
    # Enable networking
    networking={
      networkmanager={
        enable = true;
        enableStrongSwan = true;
      };
      hostName = config.systemConfig.hostname;
    };
    services={
      xl2tpd.enable = true;
      strongswan.enable = true;
      strongswan.secrets = [
        "ipsec.d/ipsec.nm-l2tp.secrets"
      ];
    };
  };
}