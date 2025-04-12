{config, pkgs, ...}:
{
  imports = [
    ./nm-wait-online.nix
  ];

  home={
    packages = [pkgs.rclone];
    shellAliases = {
      "reload-rclone"="systemctl --user restart rCloneMounts.service";
    };
  };

  systemd.user.services={
    rCloneMounts = {
      Unit = {
        Description = "Mount all rClone configurations";
        After = [ "NetworkManager-wait-online.service" ];
        Requires = [ "NetworkManager-wait-online.service" ];
      };
      Service = let home = config.home.homeDirectory; in {
        Type = "forking";
        ExecStartPre = "${pkgs.writeShellScript "rClonePre" ''
        if ${pkgs.networkmanager}/bin/nm-online
        then
          remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
          for remote in $remotes;
          do
            name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
            /usr/bin/env mkdir -p ${home}/"$name"
          done
        fi
        '' }";
        
        ExecStart = "${pkgs.writeShellScript "rCloneStart" ''
        if ${pkgs.networkmanager}/bin/nm-online
        then
          remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
          for remote in $remotes;
          do
            name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
            ${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount --allow-non-empty "$remote" "$name" &
          done
        fi
        '' }";

        ExecStop = "${pkgs.writeShellScript "rCloneStop" ''
        remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
        for remote in $remotes;
        do
        name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
        /usr/bin/env fusermount -u ${home}/"$name"
        done
        '' }";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}