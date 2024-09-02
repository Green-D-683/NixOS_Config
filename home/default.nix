{config, pkgs, lib, ...}:
let
getUsers = dir : builtins.attrValues (builtins.mapAttrs (name: _: "${name}") (lib.attrsets.filterAttrs (name: type: (type=="directory")) (builtins.readDir dir)));

getUserConfigs = users: builtins.map (name: ./. + "/${name}/${name}.nix") users;
in
{
  imports = getUserConfigs(getUsers(./.));

  options = {
    userConfig = {
      users = lib.mkOption{
        default = ["daniel"];
        type = with types; listOf emum (getUsers(./.));
        description = "The users to include for the device";
      };
    };
  };

  config = {
    home-manager = {
        users = lib.mkMerge (
          builtins.map (name: {name = import "./${name}/home/home.nix" {pkgs = pkgs; lib = lib; };}) config.userConfig.users ## TODO: This might work? Fix if not
        );
    };
  };
  
}