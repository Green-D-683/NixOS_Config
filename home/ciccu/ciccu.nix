{config, pkgs, lib, ...}:

{
  config = {
    users.users.ciccu = lib.mkIf (builtins.elem "ciccu" config.userConfig.users) {
      isNormalUser = true;
      description = "CICCU Tech";
      extraGroups = [
        "networkmanager"
      ];
      hashedPassword = "$y$j9T$F7aAtyS1ewq0TVR7vgpFz0$zfCR4BQn.Q3D/NJpoTC1UFrHOia.X80BKdL/LfVFjRA";
    };
  };
}
