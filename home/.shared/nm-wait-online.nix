{pkgs, ...}:
{
  # Copy of NetworkManager-wait-online system-level service
  systemd.user.services.NetworkManager-wait-online = {
    Unit = {
      Description = "Network Manager Wait Online";
      Documentation = "man:NetworkManager-wait-online.service(8)";
    };
    Service={
      Type="oneshot";
      ExecStart="${pkgs.networkmanager}/bin/nm-online -s -q";
      RemainAfterExit="yes";
      Environment="NM_ONLINE_TIMEOUT=60";
    };
    Install={
      WantedBy=["default.target"];
    };
  };
}