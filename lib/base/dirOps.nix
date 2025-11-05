{lib, ...}:
let
getNixFilesF = dir : builtins.attrValues (builtins.mapAttrs (name: _: "${dir}/${name}") (lib.attrsets.filterAttrs (name: _: (lib.hasSuffix ".nix" name) && !(name == "default.nix")) (builtins.readDir dir)));

getSubDirNamesF = dir : builtins.attrValues (builtins.mapAttrs (name: _: "${name}") (lib.attrsets.filterAttrs (name: type: (type=="directory")) (builtins.readDir dir)));

importerF = f: args: import f args;

importAllF = fs: args: builtins.map (f: importerF f args) fs;

filterSecrets = lib.lists.filter (d: d != "secrets" );

in rec
{
  getDir = (
    dir: getNixFilesF dir);

  getDirNamesOnly = (
    dir: builtins.map (str: lib.strings.removeSuffix ".nix" (lib.strings.removePrefix "${dir}/" str)) (getDir dir)
  );

  getDirRec = dir: withSecrets: (
    getDir dir ++ (
        let
            withSecretsDirs = getSubDirNames dir;
            subDirs = if withSecrets then withSecretsDirs else filterSecrets withSecretsDirs;
        in
            if (subDirs != []) then
                lib.lists.flatten (builtins.map (subdir: (getDirRec "${dir}/${subdir}" withSecrets )) subDirs )
            else
                []
        )
    );

  getSubDirNames = (
    dir: builtins.filter (x: !(lib.strings.hasPrefix "." x)) (getSubDirNamesF(dir)));

  getSubDirNamesAll = ( dir:
    getSubDirNamesF dir
  );

  getSubDirs = (
    dir: builtins.map (name: "${dir}/${name}") (getSubDirNames dir));

  getSubDirsAll = (
    dir: builtins.map (name: "${dir}/${name}") (getSubDirNamesAll dir)
  );

  importDir = ( dir: args:
    importAllF (getDir dir) args);

  importDirRec = ( dir: withSecrets: args:
    importAllF (getDirRec dir withSecrets) args);
}
