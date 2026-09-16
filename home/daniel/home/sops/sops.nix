{config, ...}:{
    config = {
        sops = {
            secrets = {
                Config-Sops-Key = {
                    format = "binary";
                    sopsFile = ./NixOS_Config-sops.txt;
                    path = "${config.xdg.configHome}/sops/age/NixOS_Config.txt";
                };
                Config-Crypt-Key = {
                    format = "binary";
                    sopsFile = ./NixOS_Config-crypt.bin;
                    path = "${config.xdg.configHome}/git-crypt/NixOS_Config";
                };
                srcf-ssh-uname = {
                    format = "binary";
                    sopsFile = ./srcf-ssh-uname.txt;
                    path = "${config.home.homeDirectory}/.ssh/config.d/srcf-uname";
                };
            };
        };

        programs.ssh.includes = [
            "${config.home.homeDirectory}/.ssh/config.d/srcf-uname"
        ];
    };
}
