{
    pkgs,
    lib,
    ...
}: {
    config = {
        nix = {
            package = pkgs.nixVersions.stable;
            settings = {
                flake-registry = "";
                auto-optimise-store = true;
                trusted-users = [
                    "@wheel"
                ];
                sandbox = true;
                extra-sandbox-paths = ["/dev" "/sys" "/proc"];
            };
            extraOptions = ''
                experimental-features = nix-command flakes
                warn-dirty = false
            '';
            registry = lib.registry.getRegistry;
        };
    };
}
