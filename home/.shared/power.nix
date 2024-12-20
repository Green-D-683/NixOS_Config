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
    AC = lib.mkMerge [
      common
      {
        powerProfile = "performance";
      }
    ];
    battery = lib.mkMerge [
      common
      {
        powerProfile = "powerSaving";
      }
    ];
    lowBattery = lib.mkMerge [
      common
      {
        displayBrightness = 5;
        powerProfile = "powerSaving";
      }
    ];
    general.pausePlayersOnSuspend = true;
    batteryLevels = {
      lowLevel = 10;
      criticalLevel = 2;
      criticalAction = "shutDown";
    };
  };
}