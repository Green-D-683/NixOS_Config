{inputs, config, lib, ...}:{

    options.sopsDir = lib.mkOption {
        type = lib.types.path;
        default = "${config.userModulemoduleDir}/${config.home.username}/home/sops/";
    };

    config = {
        sops = {
            age.keyFile = "${config.home.homeDirectory}/.sops_key.txt";
        };
    };
}
