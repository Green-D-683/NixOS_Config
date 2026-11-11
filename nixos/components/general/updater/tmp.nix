{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        systemd.services = {
            set_etc_nixos_perm = {
                enable = true;
                description = "Set /etc/nixos permissions";
                wantedBy = ["multi-user.target"];
                script = ''
                    # Ensure /etc/nixos has the correct permissions
                    chown root:wheel /etc/nixos
                    chmod 774 /etc/nixos
                    # Ensure /etc/nixos/NixOS_Config has the correct permissions
                    if [ -d /etc/nixos/NixOS_Config ]; then
                        chown -R root:wheel /etc/nixos/NixOS_Config
                        chmod -R 774 /etc/nixos/NixOS_Config
                    fi
                '';
            };
            update_config = {
                enable = true;
                description = "Update NixOS repository";
                requires = ["set_etc_nixos_perm.service" "NetworkManager-wait-online.service"];
                script = let
                    dir = "/etc/nixos/NixOS_Config";
                    gitpkg = "${pkgs.git}/bin/git";
                    git = "${gitpkg} -C ${dir}";
                    remote = "git@github.com:Green-D-683/NixOS_Config.git";
                in '' # TODO This will still fail if root has not previously known GitHub
            export PATH="${pkgs.opensshWithKerberos}/bin:$PATH"
            eval `ssh-agent -s`
            ssh-add pull_key
            if [ ! -d ${dir} ]; then
                echo "Git repository ${dir} does not exist, cloning it."
                ${gitpkg} clone ${remote}
            fi
            export BRANCH=$(${git} branch --show-current)
            ${git} switch main
            ${git} pull
            ${git} switch "$BRANCH"
        '';
                serviceConfig = {
                    WorkingDirectory = "/etc/nixos";
                };
            };
        };
        environment.etc."nixos/pull_key" = {
            source = ./pull_key;
            mode = "0600"; # Restrict permissions to allow ssh-add
        };
    };
}
