{config, pkgs, lib, ...}:
let
users = lib.getSubDirNames ./.;

getUserConfigs = builtins.map (name: ./. + "/${name}/${name}.nix") users;
in
{
  imports = getUserConfigs;

  options = {
    userConfig = {
      users = lib.mkOption{
        type = lib.types.listOf (lib.types.enum users);
      };
    };
  };

  config = {
    home-manager = {
        users = lib.mkMerge (
          (builtins.map (name: {name = import "./${name}/home/home.nix" {inherit pkgs; inherit lib; };}) config.userConfig.users) ## TODO: This might work? Fix if not
        );
    };

    users.mutableUsers = true;
  };
  
}