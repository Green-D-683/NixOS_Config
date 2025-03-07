{config, lib, ...}:

{
  config = lib.mkIf (config.systemConfig.optimiseFor == "server") {
    services.openssh= {
      enable = true;
      settings = {
        X11Forwarding = true;
      };
    };
  };
}