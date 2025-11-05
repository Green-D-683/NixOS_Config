{lib, self}:

# let importDirRec = (import ./dirOps.nix {inherit lib;}).importDirRec;
# in (lib.lists.foldr (a: b: a//b) {} (importDirRec ./. {inherit lib self;}))

let
importDirRec = (import ./base/dirOps.nix {inherit lib;}).importDirRec;
attrListMerge = (import ./base/attrListMerge.nix {inherit lib;}).attrListMerge;

base = attrListMerge (importDirRec ./base true {inherit lib self;});
libBase = lib.extend(_: _: base);

aug = attrListMerge (importDirRec ./aug true {inherit self; lib = libBase;});
in base // aug
