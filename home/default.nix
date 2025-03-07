{self, config, pkgs, lib, inputs, ...}:
let
users = lib.getSubDirNames ./.;

getUserConfigs = builtins.map (name: ./. + "/${name}/${name}.nix") users;
in
{
  imports = getUserConfigs ++ [inputs.home-manager.nixosModules.home-manager];

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
              system = pkgs.system;
              flake = self;
            };
          }
          self.homeManagerModules.shared
          inputs.plasma-manager.homeManagerModules.plasma-manager
        ];
        backupFileExtension = "backup";
    };

    users = {
      mutableUsers = true;
      groups = {
        users = {
          name = "users";
          members = config.userConfig.users;
        };
      };
    };
  };
  
}