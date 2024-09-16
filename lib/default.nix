{lib, self}:

let importDirRec = (import ./dirOps.nix {inherit lib;}).importDirRec;
in (lib.lists.foldr (a: b: a//b) {} (importDirRec ./. {inherit lib self;}))
