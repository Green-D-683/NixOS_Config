{config, lib, ...}:

{
  config = lib.mkIf (builtins.elem "daniel" config.userConfig.users) {
    users.users.daniel = {
      isNormalUser = true;
      description = "Daniel";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "gamemode"
      ];
    };
  };
}