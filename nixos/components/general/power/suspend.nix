{...}: {
    config = {
        # suspend to RAM (deep) rather than `s2idle`
        boot.kernelParams = ["mem_sleep_default=deep"];
        # suspend-then-hibernate
        systemd.sleep.settings.Sleep = {
            HibernateDelaySec = "30m";
            HibernateOnACPower = "yes";
            SuspendState = "mem";
        };
        systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
    };
}
