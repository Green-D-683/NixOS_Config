{config, pkgs, ...}:

{
  config={
    programs={
      # Steam
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
        dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
      };
    };

    ## Steam dependencies
    hardware.opengl={
      enable=true;
      driSupport=true;
      driSupport32Bit=true;
    };

    environment.systemPackages = with pkgs; [
      # Steam
      steam
      steam-run
    ];
  };
}