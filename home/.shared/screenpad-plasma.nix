{lib, config, pkgs, ...}:
{
  programs.plasma = lib.mkIf (lib.attrsets.attrByPath ["hasScreenpad"] false config.args.cfg)  {
    hotkeys = {
      commands = {
        "toggleScreenpad" = {
          command = "${pkgs.toggle-screenpad}/bin/toggle-screenpad";
          comment = "Turn the ScreenPad On or Off, and position it properly";
          keys = [
            "Launch (1)"
            "ScrollLock"
          ];
          logs.enabled = true;
          name = "Toggle Screenpad";
        };
        "enableMainScreen" = {
            command = "${pkgs.writeScript "set-main-screen" ''
            kscreen-doctor output.eDP-1.disable
            kscreen-doctor output.eDP-1.enable output.eDP-1.priority.1
            ''}";
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
