{config, pkgs, ...}:

{ 
  config={
    # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;
  
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