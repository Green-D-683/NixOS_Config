{
  config,
  lib,
  pkgs,
  ...
}:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestZFSKernel = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  config = lib.mkIf (builtins.elem "zfs" config.systemConfig.servers.basic) {
    # Note this might jump back and forth as kernels are added or removed.
    boot = {
        kernelPackages = lib.mkForce latestZFSKernel;
        supportedFilesystems = [ "zfs" ];
        zfs.forceImportRoot = false;
    };

    environment.systemPackages = [ pkgs.zfs ];
  };
}
