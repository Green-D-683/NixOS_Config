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

  };
}