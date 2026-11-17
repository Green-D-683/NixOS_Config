{lib, ...}: {
    options = let
        mkOption = lib.mkOption;
        types = lib.types;
    in {
        systemConfig = {
            virtualisationTools = mkOption {
                # Each other nix file in this directory defines an option here
                type = with types; listOf (enum (lib.lists.remove "core" (lib.dirOps.getDirNamesOnly ./.)));
                default = [];
                description = "Virtualisation Interfaces to include";
            };
        };
    };
}
