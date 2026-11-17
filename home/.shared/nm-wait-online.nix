{pkgs, ...}: {
    # Copy of NetworkManager-wait-online system-level service
    systemd.user = {
        services.network-wait-online = {
            Unit.Description = "Network Wait Online";
            Service = {
                Type = "oneshot";
                ExecStart = let
                    systemctl = "${pkgs.systemd}/bin/systemctl";
                in
                    pkgs.writeShellScript "network-wait-online" ''
                        if ${systemctl} is-active --quiet NetworkManager.service; then
                            exec ${pkgs.networkmanager}/bin/nm-online -s -q
                        elif ${systemctl} is-active --quiet systemd-networkd.service; then
                            exec ${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online
                        elif ${systemctl} is-active --quiet network-online.target; then
                            # Fallback: scripted networking, ifupdown, dhcpcd, etc.
                            exit 0
                        else
                            echo "No supported network manager is running" >&2
                            exit 1
                        fi
                    '';
                RemainAfterExit = "yes";
                Restart = "on-failure";
                RestartSec = 60;
                ExecStartPost = "systemctl --user start --no-block network-dependent.target";
            };
        };
        timers.network-wait-online = {
            Unit.Description = "Start network gate after activation";
            Timer = {
                OnActiveSec = "1s";
                Unit = "network-wait-online.service";
            };
            Install.WantedBy = ["timers.target"];
        };
        targets.network-dependent = {
            Unit.Description = "Start Network-Dependent Services, triggered on completion of network-wait-online.service";
            Target = {};
        };
    };
}
