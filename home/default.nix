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
            (import ./${name}/home/default.nix {withSecrets = true;} {inherit pkgs lib cfg;});}) config.userConfig.users)
        );
        sharedModules = [
          {
            config.args = {
              cfg = config.userConfig;
              system = pkgs.stdenv.hostPlatform.system;
              flake = self;
              isNixOS = true;
            };
          }
          self.homeManagerModules.shared
          inputs.plasma-manager.homeModules.plasma-manager
        ];
        backupFileExtension = "backup";
    };

    users = {
      mutableUsers = true;
      groups = lib.mkMerge ([
        {
          users = {
            name = "users";
            members = config.userConfig.users;
          };
        }
      ] ++ (lib.lists.map (u: {${u}={};}) config.userConfig.users)); # these two lines temporary until https://github.com/NixOS/nixpkgs/pull/199705 merged
      users = lib.mkMerge (lib.lists.map (u: {${u} = {group=u;homeMode="750";};}) config.userConfig.users);
    };

    systemd.services.user-sleep-bridge = {
      description = "Bridge system suspend to user instance";
      wantedBy = [ "suspend.target" "suspend-then-hibernate.target" "hibernate.target" ];
      after = [ "suspend.target" "suspend-then-hibernate.target" "hibernate.target" ];
      serviceConfig = {
        Type = "oneshot";
        # Replace 'your-username' with your actual username
        ExecStart = "${pkgs.writeShellScript "bridge-user-sleep" (lib.strings.concatMapStringsSep "\n" (user: "/run/current-system/sw/bin/systemctl --user --machine=${user}@ start sleep.target") config.userConfig.users)}";
      };
    };
  };
}
