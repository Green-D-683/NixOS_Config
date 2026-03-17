{config, pkgs, lib, ...}:

{
    options = let
    mkOption = lib.mkOption;
    types = lib.types;
    in {
        systemConfig={
            virtualisationTools = mkOption {
              type = with types; listOf (enum [
                "waydroid"
                "virtualbox"
                "docker"
                "distrobox"
              ]);
            };
        };
    };
    config = let virtOpts = config.systemConfig.virtualisationTools; in {
        environment = {
            etc."distrobox/distrobox.conf".text = if (builtins.elem "distrobox" virtOpts) then ''
                container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
            '' else "";
            systemPackages = with pkgs; (lib.optionals (builtins.elem "distrobox" virtOpts) ([ distrobox ] ++ (lib.optionals (config.systemConfig.graphicalEnv) [ boxbuddy ])));
        };

        virtualisation = {
            podman = lib.mkIf (builtins.elem "distrobox" virtOpts) {
              enable = true;
              dockerCompat = true;
            };

            waydroid.enable = builtins.elem "waydroid" virtOpts;

            docker.enable = (builtins.elem "docker" virtOpts && !(builtins.elem "distrobox" virtOpts));
            #vmware = {
            #  host = {
            #    enable = true;
            #    extraPackages = with pkgs; [
            #      ntfs3g
            #    ];
            #  };
                # guest = {
                #   enable = true;
                # };
            # };
            virtualbox = lib.mkIf (builtins.elem "virtualbox" virtOpts) {
                host = {
                enable = true;
                enableExtensionPack = true;
                # enableKvm = true;
                # addNetworkInterface = false;
                };
            };
        };
        # programs = {
        #   darling.enable = true;
        # };
        boot = {
            kernelParams = lib.mkIf (builtins.elem "virtualbox" virtOpts) [ "kvm.enable_virt_at_load=0" ];
        } // lib.mkIf (builtins.elem "virtualbox" virtOpts) {
            # Temporary override kernel version for virtualbox support - https://github.com/VirtualBox/virtualbox/issues/467
            kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;
        };
    };
}
