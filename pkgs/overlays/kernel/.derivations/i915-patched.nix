{
    stdenv,
    fetchurl,
    kernel,
    kernelModuleMakeFlags,
}:
stdenv.mkDerivation {
    pname = "i915-patched";
    inherit (kernel) version src;

    patches = [
        (fetchurl {
            url = "https://lore.kernel.org/intel-gfx/tencent_29E977263911A2CF7F7754DEC2963C49D808@qq.com/raw";
            hash = "sha256-AOZaxitsDACu7Yt1PM41a8xycWkLBt9kkZjHdiykJZY=";
        })
    ];

    nativeBuildInputs = kernel.moduleBuildDependencies;
    makeFlags =
        kernelModuleMakeFlags
        ++ [
            "-C"
            "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        ];

    preBuild = ''
        makeFlagsArray+=("M=$PWD/drivers/gpu/drm/i915")
        buildFlagsArray+=("KCFLAGS=-I$PWD/include/trace")
    '';

    buildFlags = ["modules"];

    installFlags = [
        "INSTALL_MOD_PATH=${placeholder "out"}"
        "INSTALL_MOD_DIR=extra"
        "DEPMOD=true"
    ];
    installTargets = ["modules_install"];
}
