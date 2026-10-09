{pkgs,...}:
pkgs.callPackage
(
  {
    stdenv,
    lib,
    fetchFromGitHub,
    cmake,
    meson,
    ninja,
    pkg-config,
    gtk3,
    glib,
    libdbusmenu-gtk3,
    patchelf,
    ...
  }:
  stdenv.mkDerivation rec {
    pname = "appmenu-gtk-module-wayland";
    version = "dd1a743a5a39e7bbe925497e537ab4e83ca8ebb9";
    src = fetchFromGitHub {
      owner = "rocka";
      repo = "appmenu-gtk-module-wayland";
      rev = version;
      hash = "sha256-cTgrITeqGtGFq5akxIWYruImp780Lgflz2y2bger9MM=";
      fetchSubmodules = true;
    };
    postPatch = ''
    cat << 'EOF' > replacement.c

    static void initialize_appmenu_module(void)
    {
        static gboolean initialized = FALSE;
        if (!initialized && gtk_module_should_run())
        {
            initialized = TRUE;
            watch_registrar_dbus();
            store_pre_hijacked();
            hijack_menu_bar_class_vtable(GTK_TYPE_MENU_BAR);
        }
    }

    G_MODULE_EXPORT void gtk_module_display_init(GdkDisplay *display)
    {
        initialize_appmenu_module();
    }
    EOF

    # Remove the old gtk_module_init block and append our new code at the end of the file
    cat replacement.c >> src/appmenu-gtk-module.c
    '';
    stripping = false;
    nativeBuildInputs =[ cmake pkg-config patchelf ];
    buildInputs = [ gtk3 glib libdbusmenu-gtk3 ];
    NIX_LDFLAGS = "-ldbusmenu-gtk3 -ldbusmenu-glib";
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/gtk-3.0/modules/
      install -D -m755 libappmenu-gtk-module-wayland.so $out/lib/gtk-3.0/modules/libappmenu-gtk-module.so
      install -D -m755 libdbusmenu/libdbusmenu-glib.so $out/lib/libdbusmenu-glib.so
      runHook postInstall
    '';
    postInstall = ''
      patchelf --print-rpath "$out/lib/gtk-3.0/modules/libappmenu-gtk-module.so"
      patchelf --shrink-rpath --allowed-rpath-prefixes /nix/store "$out/lib/gtk-3.0/modules/libappmenu-gtk-module.so"
      patchelf --print-rpath "$out/lib/gtk-3.0/modules/libappmenu-gtk-module.so"
    '';
  }
) {}
