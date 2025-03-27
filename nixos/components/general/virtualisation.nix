{config, pkgs, ...}:

{
  config = {
    virtualisation = let virtOpts = config.systemConfig.virtualisationTools; in {
      waydroid.enable = builtins.elem "waydroid" virtOpts;

      docker.enable = builtins.elem "docker" virtOpts;
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
      virtualbox = (
        if (builtins.elem "virtualbox" virtOpts) then {
          host = {
            enable = true;
            enableExtensionPack = true;
          };
        } else {}
      );
    };
    # programs = {
    #   darling.enable = true;
    # };
  };
}
