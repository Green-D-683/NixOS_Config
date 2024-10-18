{config, pkgs, ...}:

{
  config = {
    virtualisation = {
      waydroid.enable = true;

      docker.enable=true;
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
     virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
     };
    };
    # programs = {
    #   darling.enable = true;
    # };
  };
}
