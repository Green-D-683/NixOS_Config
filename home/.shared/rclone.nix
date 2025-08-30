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
        remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
        for remote in $remotes;
        do
          name=$(${pkgs.coreutils}/bin/echo "$remote" | ${pkgs.gnused}/bin/sed "s/://g")
          ${pkgs.coreutils}/bin/mkdir -p "${home}/$name"
        done
        '' }";
        
        ExecStart = "${pkgs.writeShellScript "rCloneStart" ''
        remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
        for remote in $remotes;
        do
          name=$(${pkgs.coreutils}/bin/echo "$remote" | ${pkgs.gnused}/bin/sed "s/://g")
          ${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount --allow-non-empty "$remote" "$name" &
        done
        '' }";

        ExecStop = "${pkgs.writeShellScript "rCloneStop" ''
        remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
        for remote in $remotes;
        do
        name=$(${pkgs.coreutils}/bin/echo "$remote" | ${pkgs.gnused}/bin/sed "s/://g")
        ${pkgs.fuse3}/bin/fusermount3 -uz "${home}/$name"
        done
        '' }";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}