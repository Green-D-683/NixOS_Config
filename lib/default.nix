{lib, self}:

# let importDirRec = (import ./dirOps.nix {inherit lib;}).importDirRec;
# in (lib.lists.foldr (a: b: a//b) {} (importDirRec ./. {inherit lib self;}))

let
getDir = (import ./00-dirOps.nix {inherit lib;}).getDir;

in lib.foldl (lib: ext: lib.extend(_: _: import ext {inherit self lib;})) lib (lib.naturalSort (getDir ./.))
