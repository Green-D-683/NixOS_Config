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
          (builtins.map (name: {${name} = 
            (import ./${name}/home/home.nix {inherit pkgs; inherit lib; cfg=config.userConfig;}) // {
              imports = lib.getDir ./.;
            };}) config.userConfig.users)
        );
        sharedModules = [
          {
            programs.plasma={
              enable = true;
              immutableByDefault=true;
            };
          }
        ];
    };

    users.mutableUsers = true;
  };
  
}