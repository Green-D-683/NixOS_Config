{
    config,
    pkgs,
    lib,
    ...
}: {
    config = {
        # Configure console
        console = {
            keyMap = "uk";
            earlySetup = true;
            packages = with pkgs; [terminus_font];
            font = "ter-u28n";
        };

        services.kmscon = {
            # KMSCon doesn't want to actually show ttys at the moment, so disable for now
            enable = false;
            config = lib.mkDefault {
                font-size = 24;
                font-name = "Source Code Pro";
            };
        };

        fonts.packages = with pkgs; [termfont];
    };
}
