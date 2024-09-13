{lib}:
{
  getUser = (
    userConfig: user: lib.attrsets.attrByPath [ "userModules" "${user}" ] userConfig.userModules."default" userConfig
  );

  userModule = let
    types = lib.types;
    mkOption = lib.mkOption;
    in
    (types.submodule {
        options.install-lists = mkOption {
          type = with types; listOf (enum (lib.getDirNamesOnly ../pkgs/programs));
          default = [];
          description = "This config includes several pre-defined lists of packages to be able to be installed. Select those desired for this user from here.";
        };
    });
}