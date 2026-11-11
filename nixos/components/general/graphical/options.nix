{
    config,
    pkgs,
    lib,
    ...
}: {
    options = let
        mkOption = lib.mkOption;
        mkEnableOption = lib.mkEnableOption;
        types = lib.types;
    in {
        systemConfig = {
            ## Graphical User Environment
            graphicalEnv = mkEnableOption "Graphical User Interface";
            gpu = mkOption {
                default = "";
                type = types.enum ["" "intel" "nvidia" "amd"];
            };
            niceties = {};
        };
    };
}
