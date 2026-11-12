{lib, ...}: let
    getNixFilesF = dir: builtins.attrValues (builtins.mapAttrs (name: _: "${dir}/${name}") (lib.attrsets.filterAttrs (name: _: (lib.hasSuffix ".nix" name) && !(name == "default.nix")) (builtins.readDir dir)));

    getSubDirNamesF = dir: builtins.attrValues (builtins.mapAttrs (name: _: "${name}") (lib.attrsets.filterAttrs (name: type: (type == "directory")) (builtins.readDir dir)));

    importerF = f: args: import f args;

    importAllF = fs: args: builtins.map (f: importerF f args) fs;

    dirOps = rec
    {
        mapDirRec = f: dir: let
            imm = f dir;
            subDirs = getSubDirNames dir;
        in
            if (subDirs != [])
            then imm ++ (lib.lists.flatten (builtins.map (subdir: (mapDirRec f "${dir}/${subdir}")) subDirs))
            else imm;

        getDir = getNixFilesF;

        getDirNamesOnly = (
            dir: builtins.map (str: lib.strings.removeSuffix ".nix" (lib.strings.removePrefix "${dir}/" str)) (getDir dir)
        );

        getDirRec = mapDirRec getDir;

        getSubDirNames = (
            dir: builtins.filter (x: !(lib.strings.hasPrefix "." x)) (getSubDirNamesF dir)
        );

        getSubDirNamesAll = (
            dir:
                getSubDirNamesF dir
        );

        getSubDirs = (
            dir: builtins.map (name: "${dir}/${name}") (getSubDirNames dir)
        );

        getSubDirsAll = (
            dir: builtins.map (name: "${dir}/${name}") (getSubDirNamesAll dir)
        );

        importDir = dir: args:
            importAllF (getDir dir) args;

        importDirRec = dir: args:
            importAllF (getDirRec dir) args;

        findFile = find: dir: builtins.filter (lib.hasSuffix find) (getDir dir);

        findFileRec = find: mapDirRec (findFile find);

        findDirRec = find: mapDirRec (dir: lib.optional (builtins.elem find (getSubDirNames dir)) "${dir}/${find}");

        getParent = builtins.dirOf;

        getParentName = dir: let
            hierarchy = lib.splitString "/" dir;
            dirName = lib.last hierarchy;
            parentPath = lib.remove dirName hierarchy;
        in
            builtins.unsafeDiscardStringContext (lib.last parentPath);
    };
in
    {
        inherit dirOps;
    }
    // dirOps
