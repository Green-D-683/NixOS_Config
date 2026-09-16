{lib, self, ...}: rec
{
  getUser = (
    user: userConfig: if userConfig.userModules ? ${user} then userConfig.userModules.${user} else userConfig.userModules."default"
  );

  userModulesDir = "${self.outPath}/home";

  userModulesDirs = lib.userModulesDirs or []; # default if undefined

  availableUsers = lib.unique (lib.lists.flatten (builtins.map lib.getSubDirNames ([userModulesDir] ++ userModulesDirs)));

  userModule = uname: let
    types = lib.types;
    mkOption = lib.mkOption;
    mkEnableOption = lib.mkEnableOption;
    in
    (types.submodule {
        options = {
            install-lists = mkOption {
                type = with types; listOf (enum (self.packageListNames));
                default = [];
                description = "This config includes several pre-defined lists of packages to be able to be installed. Select those desired for this user from here.";
            };
            gui = mkEnableOption "GUI Package Configuration";
            moduleDir = mkOption {
                type = lib.types.path;
                default = userModulesDir;
                description = "Directory containing the user's configuration options - must be set to not use the default";
            };
            sopsKey = mkOption {
                type = lib.types.path;
                default = "${self.outPath}/sops/system/user-${uname}-key.txt";
                description = "Key for the user's home sops secrets";
            };
        };
    });

  userModules = lib.types.submodule {options = (lib.attrListMerge (builtins.map (user: {${user} = lib.mkOption {type = userModule user; description = "Configuration for user '${user}'";};}) (availableUsers ++ ["default"])));};
}
