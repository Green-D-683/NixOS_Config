{lib, self}:
let getDir = (import ./00-dirOps.nix {inherit lib;}).getDir;
in lib.foldl (mylib: ext: mylib // import ext {inherit self; lib=lib.extend (_: _: mylib);}) {} (lib.naturalSort (getDir ./.))
