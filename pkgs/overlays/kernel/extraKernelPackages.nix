{
  lib,
  ...
}: final: prev: {
    kernelPackagesExtensions =
        prev.kernelPackagesExtensions
        ++ [
            (kfinal: kprev:
                lib.genAttrs
                (lib.dirOps.getDirNamesOnly ./.derivations)
                (f: kfinal.callPackage ./.derivations/${f}.nix {}))
        ];
}
