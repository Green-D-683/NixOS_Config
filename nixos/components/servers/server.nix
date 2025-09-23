{config, lib, ...}:

{
  options.systemConfig.servers = let
    mkEnableOption = lib.mkEnableOption;
    mkOption = lib.mkOption;
    types = lib.types;
  in {
    enable = mkEnableOption "Servers";
    basic = mkOption {
      default = [];
      type = with types; listOf (enum [
        "pihole"
        "zfs"
      ]);
    };
    # Specified in [router.nix](./router.nix)
    #router =
  };

  config = lib.mkIf (config.systemConfig.optimiseFor == "server") {
    services.openssh= {
      enable = true;
      settings = {
        X11Forwarding = true;
      };
    };
  };
}
