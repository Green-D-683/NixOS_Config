{config, pkgs, lib, ...}:{
    config = lib.mkIf (config.userModule.gui) {
        services = {
          kdeconnect = {
            enable = true;
            package = pkgs.kdeConnect;
          };
        };
    };
}
