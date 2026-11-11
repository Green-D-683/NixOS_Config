{
    config,
    pkgs,
    lib,
    ...
}: {
    config = lib.mkIf (builtins.elem "distrobox" config.systemConfig.virtualisationTools) {
        etc."distrobox/distrobox.conf".text = ''
            container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
        '';
        systemPackages = with pkgs; [distrobox] ++ (lib.optionals (config.systemConfig.graphicalEnv) [boxbuddy]);
    };
}
