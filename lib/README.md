# Custom Nix Function Library

Imports are handled in `default.nix` in a similar manner to POSIX `conf.d` directories:

```nix
{lib, self}:
let getDir = (import ./00-dirOps.nix {inherit lib;}).getDir;
in lib.foldl (mylib: ext: mylib // import ext {inherit self; lib=lib.extend (_: _: mylib);}) {} (lib.naturalSort (getDir ./.))
```

That is, files are imported in numerical order, with the previous files' functions in the extended lib scope.

## Functions available:

<!-- TODO -->
