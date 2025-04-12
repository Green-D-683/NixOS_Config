{config, pkgs, lib, ...}:
{
  config = lib.mkIf config.programs.thunderbird.enable {
    systemd.user = {
      services={
        thunderbird-sync = {
          Unit = {
            Description = "Run Thunderbird headless to sync mail";
            After = [ "NetworkManager-wait-online.service" ];
            Requires = [ "NetworkManager-wait-online.service" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.coreutils}/bin/timeout 30 ${pkgs.thunderbird}/bin/thunderbird --headless";
          };
        };
      };
      timers = {
        thunderbird-sync = {
          Unit = {
            Description = "Run Thunderbird headless on a timer to sync mail";
          };
          Timer={
            OnCalendar="hourly";
            Unit="thunderbird-sync.service";
            Persistent=true;
          };
          Install={
            WantedBy= [ "timers.target" ];
          };
        };
      };
    };
  };
}