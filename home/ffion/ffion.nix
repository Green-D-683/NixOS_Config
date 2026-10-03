{config, lib, ...}:

{
  config = lib.mkIf (builtins.elem "ffion" config.userConfig.users) {
    users.users.ffion = {
      isNormalUser = true;
      description = "Ffion";
      extraGroups = [
        "networkmanager"
        "wheel"
        "gamemode"
        "vboxusers"
      ];
      initialHashedPassword = "$y$j9T$zPzNZNuQXf7cPQr2n6IW00$ooxsQQp19tqX4Yy7QVtbbxgAgV1kMdD3PJCP01ajk58";
    };
  };
}
