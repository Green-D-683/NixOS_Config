{pkgs, ...}:
{
  # Copy of NetworkManager-wait-online system-level service
  systemd.user = {
    services.NetworkManager-wait-online = {
      Unit.Description = "Network Manager Wait Online";
      Service={
        Type="oneshot";
        ExecStart="${pkgs.networkmanager}/bin/nm-online -s -q";
        RemainAfterExit="yes";
        Restart = "on-failure";
        RestartSec = 60;
        ExecStartPost = "systemctl --user start --no-block network-dependent.target";
      };
    };
    timers.NetworkManager-wait-online = {
      Unit.Description = "Start network gate after activation";
      Timer = {
        OnActiveSec = "1s";
        Unit = "NetworkManager-wait-online.service";
      };
      Install.WantedBy = [ "timers.target" ];
    };
    targets.network-dependent = {
      Unit.Description = "Start Network-Dependent Services, triggered on completion of NetworkManager-wait-online.service";
      Target = {};
    };
  };
}