{config, lib, ...}:
{
  programs.plasma = lib.mkIf (config.hasScreenpad)  {
    enable = true;
    hotkeys = {
      commands = {
        "toggleScreenpad" = {
          command = "toggle-screenpad";
          comment = "Turn the ScreenPad On or Off, and position it properly";
          keys = [
            "Launch (1)"
            "ScrollLock"
          ];
          logs.enabled = true;
          name = "Toggle Screenpad";
        };
        "enableMainScreen" = {
          command = "kscreen-doctor output.eDP-1.enable output.eDP-1.priority.1";
          comment = "Turn the Main Laptop Screen Back on if it decided to turn off when a new display was connected";
          name = "Enable Main Screen";
          keys = [
            "Meta+P"
          ];
        };
      };
    };
  };
}