{lib, ...}: {
    options = let
        mkOption = lib.mkOption;
        types = lib.types;
    in {
        systemConfig = {
            virtualisationTools = mkOption {
                type = with types;
                # Each other nix file in this directory defines an option here
                    listOf (enum (lib.lists.remove "core" (lib.dirOps.getDirNamesOnly ./.)));
            };
        };
    };
}
