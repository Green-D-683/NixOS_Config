{
    stdenv,
    fetchurl,
    kernel,
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

    # Only the i915 directory needs to be built
    buildPhase = ''
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
          M=$(pwd)/drivers/gpu/drm/i915 \
          KCFLAGS="-I$(pwd)/include/trace" \
          modules
    '';

    installPhase = ''
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
          M=$(pwd)/drivers/gpu/drm/i915 \
          INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=extra \
          modules_install
    '';
}