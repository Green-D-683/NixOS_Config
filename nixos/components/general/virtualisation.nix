{config, pkgs, lib, ...}:

{
  config = let virtOpts = config.systemConfig.virtualisationTools; in {
    virtualisation = {
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
      virtualbox = lib.mkIf (builtins.elem "virtualbox" virtOpts) {
        host = {
          enable = true; # Wait for 6.15 update: https://github.com/NixOS/nixpkgs/pull/414106
          enableExtensionPack = true; 
          # enableKvm = true;
          # addNetworkInterface = false;
        };
      };
    };
    # programs = {
    #   darling.enable = true;
    # };
    boot.kernelParams = lib.mkIf (builtins.elem "virtualbox" virtOpts) [ "kvm.enable_virt_at_load=0" ];
  };
}
