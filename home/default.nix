{self, config, pkgs, lib, system, ...}:
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
          (builtins.map (name: let cfg = config.userConfig; in {${name} = 
            (import ./${name}/home/home.nix {inherit pkgs lib cfg;});}) config.userConfig.users)
        );
        sharedModules = [
          {
            config.args = {
              cfg = config.userConfig;
              system = system;
              flake = self;
            };
          }
          self.homeManagerModules.shared
        ];
    };

    users.mutableUsers = true;
  };
  
}