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
        useGlobalPkgs = true;
        useUserPackages = true;
        users = lib.mkMerge (
          (builtins.map (name: {${name} = import ./${name}/home/home.nix {inherit pkgs; inherit lib; config=config.userConfig;};}) config.userConfig.users) ## TODO: This might work? Fix if not
        );
        sharedModules = [
          {
            programs.plasma.immutableByDefault=true;
          }
        ] ++ lib.importDir ./. {inherit pkgs lib; config = config.userConfig;};
    };

    users.mutableUsers = true;
  };
  
}