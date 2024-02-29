{config, pkgs, ...}:

{
  config = {
    environment.systemPackages = with pkgs; [
      thunderbolt
      kdePackages.plasma-thunderbolt
    ];
    # Thunderbolt - also has packages in environment.systemPackages
    services.hardware.bolt.enable=true;
  };
}