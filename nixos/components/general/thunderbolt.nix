{config, pkgs, lib, ...}:

{
  config = lib.mkIf (builtins.elem "thunderbolt" config.systemConfig.extraHardware) {
    environment.systemPackages = with pkgs; [
      thunderbolt
      kdePackages.plasma-thunderbolt
    ];
    # Thunderbolt - also has packages in environment.systemPackages
    services.hardware.bolt.enable=true;
  };
}