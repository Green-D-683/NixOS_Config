{config, pkgs, ...}:

{
  config = {
    environment.systemPackages = [
      thunderbolt
      libsForQt5.plasma-thunderbolt
    ];
    # Thunderbolt - also has packages in environment.systemPackages
    services.hardware.bolt.enable=true;
  };
}