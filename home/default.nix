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
    }
  }
}