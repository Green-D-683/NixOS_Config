{
    lib,
    stdenv,
    fetchFromGitHub,
    kernel,
    kernelModuleMakeFlags,
}:
# Out-of-tree build of asus-wmi / asus-nb-wmi with ScreenPad support.
# Upstream: https://github.com/Plippo/asus-wmi-screenpad
#
# Upstream ships patches against the stock in-tree drivers rather than full
# sources, so this takes the three files from the kernel's own source tarball
# (kernel.src), applies the patch matching the kernel version, and builds only
# the two modules against the kernel's build tree.
#
# Use via the kernel package set, so `kernel` and `kernelModuleMakeFlags` are
# in scope:
#   boot.extraModulePackages = [
#     (config.boot.kernelPackages.callPackage ./asus-wmi-screenpad.nix { })
#   ];
let
    # Same version -> patch mapping as upstream's prepare-for-current-kernel.sh
    kver = lib.versions.majorMinor kernel.version;
    patchFile =
        if lib.versionAtLeast kver "7.0"
        then "patch7.0"
        else if lib.versionAtLeast kver "6.19"
        then "patch6.19"
        else if lib.versionAtLeast kver "6.17"
        then "patch6.17"
        else if lib.versionAtLeast kver "6.11"
        then "patch6.11"
        else if lib.versionAtLeast kver "6.2"
        then "patch6.2"
        else if lib.versionAtLeast kver "6.0"
        then "patch6.0"
        else if lib.versionAtLeast kver "5.8"
        then "patch5.8"
        else "patch";
in
    stdenv.mkDerivation {
        pname = "asus-wmi-screenpad";
        inherit (kernel) version;

        src = fetchFromGitHub {
            owner = "Plippo";
            repo = "asus-wmi-screenpad";
            rev = "0d73272fcbec89a231e09007964ac429afd9b532";
            hash = "sha256-Bg/e/I+ZSYElHeigQ+x7LZs856wdi7g7n3uvo1RWTos=";
        };

        nativeBuildInputs = kernel.moduleBuildDependencies;

        # Replace the repo's checked-in copies with the running kernel's own
        # versions of the three files, then apply the matching ScreenPad patch.
        postPatch = ''
            if [ -d ${kernel.src} ]; then
              for f in asus-wmi.c asus-nb-wmi.c asus-wmi.h; do
                cp --no-preserve=mode ${kernel.src}/drivers/platform/x86/$f .
              done
            else
              mkdir kernel-extract
              tar -xf ${kernel.src} -C kernel-extract --strip-components=1 \
                --wildcards \
                '*/drivers/platform/x86/asus-wmi.c' \
                '*/drivers/platform/x86/asus-nb-wmi.c' \
                '*/drivers/platform/x86/asus-wmi.h'
              cp kernel-extract/drivers/platform/x86/asus-{wmi.c,nb-wmi.c,wmi.h} .
              rm -rf kernel-extract
            fi

            echo "Using ${patchFile} for kernel ${kernel.version}"
            patch -p1 < ${patchFile}
        '';

        # Standard nixpkgs out-of-tree module setup. kernelModuleMakeFlags is what
        # makes modules_install emit the .ko.cer certificates that NixOS's module
        # aggregator requires.
        makeFlags =
            kernelModuleMakeFlags
            ++ [
                "-C"
                "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
            ];

        preBuild = ''
            makeFlagsArray+=("M=$PWD")
        '';

        buildFlags = ["modules"];

        # "updates" is the only directory depmod prioritises over the in-tree
        # kernel/ copy by default, so these replace the stock modules.
        installFlags = [
            "INSTALL_MOD_PATH=${placeholder "out"}"
            "INSTALL_MOD_DIR=updates"
        ];
        installTargets = ["modules_install"];

        meta = {
            description = "asus-wmi with ScreenPad brightness control for ASUS Zenbook Duo";
            homepage = "https://github.com/Plippo/asus-wmi-screenpad";
            license = lib.licenses.gpl2Plus;
            platforms = lib.platforms.linux;
        };
    }
