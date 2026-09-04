{lib, config, ...}:
let common = {
  autoSuspend.action = "nothing";
  dimDisplay.enable = false;
  inhibitLidActionWhenExternalMonitorConnected = false;
  powerButtonAction = "shutDown";
  turnOffDisplay = {
    idleTimeout = "never";
    #idleTimeoutWhenLocked = "whenLockedAndUnlocked";
  };
  whenLaptopLidClosed = "sleep";
  whenSleepingEnter = "standbyThenHibernate";
};
in
{
  programs.plasma.powerdevil = lib.mkDefault {
    AC = common // {
        powerProfile = "performance";
        inhibitLidActionWhenExternalMonitorConnected = true;
    };
    battery = common // {
        powerProfile = "powerSaving";
    };
    lowBattery = common // {
        displayBrightness = 5;
        powerProfile = "powerSaving";
    };
    general.pausePlayersOnSuspend = true;
    batteryLevels = {
      lowLevel = 10;
      criticalLevel = 2;
      criticalAction = "shutDown";
    };
  };
}
