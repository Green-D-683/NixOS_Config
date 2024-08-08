{config, pkgs, ...}:

{ 
  config={
    # Gaming
    programs={
      # Steam
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
        dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
      };
    };

    ## Steam dependencies
    
  
  };
}