{config, pkgs, ...}:

{
  config = {
    users.users.daniel = {
      isNormalUser = true;
      description = "Daniel";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };
  };
}