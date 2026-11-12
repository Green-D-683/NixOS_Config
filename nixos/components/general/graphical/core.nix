{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (config.systemConfig.graphicalEnv) {
        # Enable Appimages
        boot.binfmt.registrations.appimage = {
            wrapInterpreterInShell = false;
            interpreter = "${pkgs.appimage-run}/bin/appimage-run";
            recognitionType = "magic";
            offset = 0;
            mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
            magicOrExtension = ''\x7fELF....AI\x02'';
        };
        services = {
            # Configure X-Server and basic Keyboard
            xserver = {
                enable = true;
                # Configure keymap in X11
                xkb = {
                    variant = "";
                    layout = "gb";
                };
                excludePackages = with pkgs; [
                    xterm
                ];
            };
            # Libinput needed for Wayland
            libinput.enable = true;
        };
    };
}
