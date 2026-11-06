{config, lib, ...}:{

    options = {
        enableSops = lib.mkEnableOption "SOPS Secrets for this user";
        sopsDir = lib.mkOption {
            type = lib.types.path;
            default = "${config.userModulemoduleDir}/${config.home.username}/home/sops/";
        };
    };

    config = lib.mkMerge [
        (lib.mkIf config.enableSops {
            sops = {
                age.keyFile = "${config.home.homeDirectory}/.sops_key.txt";
            };
        })
        {
            enableSops = config.userModule.enableSops; 
        }
    ];
}
