{lib, ...}: let
    getNixFilesF = dir: builtins.attrValues (builtins.mapAttrs (name: _: "${dir}/${name}") (lib.attrsets.filterAttrs (name: _: (lib.hasSuffix ".nix" name) && !(name == "default.nix")) (builtins.readDir dir)));

    getSubDirNamesF = dir: builtins.attrValues (builtins.mapAttrs (name: _: "${name}") (lib.attrsets.filterAttrs (name: type: (type == "directory")) (builtins.readDir dir)));

    importerF = f: args: import f args;

    importAllF = fs: args: builtins.map (f: importerF f args) fs;

    dirOps = rec
    {
        getDir = getNixFilesF;

        getDirNamesOnly = (
            dir: builtins.map (str: lib.strings.removeSuffix ".nix" (lib.strings.removePrefix "${dir}/" str)) (getDir dir)
        );

        getDirRec = dir: (
            getDir dir
            ++ (
                let
                    subDirs = getSubDirNames dir;
                in
                    if (subDirs != [])
                    then lib.lists.flatten (builtins.map (subdir: (getDirRec "${dir}/${subdir}")) subDirs)
                    else []
            )
        );

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

        ## Redo to give relative paths from root

        findDirRec = find: dir: let
            subDirNames = getSubDirNames dir;
            subDirs = getSubDirs dir;
            reCall = builtins.map (findDirRec find) subDirs;
        in
            if (builtins.length subDirs == 0)
            then []
            else if (builtins.elem find subDirNames)
            then lib.lists.flatten [["${dir}/${find}"]] ++ reCall
            else lib.lists.flatten reCall;

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
