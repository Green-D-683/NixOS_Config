{config, pkgs, ...}:

{
  config = {
    virtualisation = {
      waydroid.enable = true;

      vmware = {
        host = {
          enable = true;
          extraPackages = with pkgs; [
            ntfs3g
          ];
        };
        # guest = {
        #   enable = true;
        # };
      };
    };
    # programs = {
    #   darling.enable = true;
    # };
  };
}