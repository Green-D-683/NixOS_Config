{lib}:
let 
getNixFilesF = dir : builtins.attrValues (builtins.mapAttrs (name: _: "${dir}/${name}") (lib.attrsets.filterAttrs (name: _: (lib.hasSuffix ".nix" name) && !(name == "default.nix")) (builtins.readDir dir)));

getSubDirNamesF = dir : builtins.attrValues (builtins.mapAttrs (name: _: "${name}") (lib.attrsets.filterAttrs (name: type: (type=="directory")) (builtins.readDir dir)));

importerF = f: args: import f args;

importAllF = fs: args: builtins.map (f: importerF f args) fs;

in rec
{
  getDir = (
    dir: getNixFilesF(dir));

  getDirRec = (
    dir: getDir(dir) ++ (
      let 
      subDirs = (getSubDirNames dir); 
      in 
      ( if (subDirs != []) then 
          lib.lists.flatten (
            (builtins.map (subdir: (getDirRec "${dir}/${subdir}")) subDirs ) 
          )
        else []
      )) );

  getSubDirNames = (
    dir: getSubDirNamesF(dir));

  getSubDirs = (
    dir: builtins.map (name: "./${name}") (getSubDirNames dir));

  importDir = ( dir: args:
    importAllF (getDir dir) args);

  importDirRec = ( dir: args:
    importAllF (getDirRec dir) args);
}