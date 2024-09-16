{inputs, system, ...}:
let patch = (system: import inputs.nixpkgs-openlp {inherit system; config.allowBroken = true;});
lib = inputs.nixpkgs.lib;
in
(self: super: {
  # openlp = ((patch system).openlpFull).overrideAttrs( final: prev:{
  #   LD_LIBRARY_PATH = lib.strings.concatStrings [
  #     prev.LD_LIBRARY_PATH
  #     ":"
  #     (lib.makeLibraryPath (with self; [
  #       util-linux
  #     ]))
  #   ];
  #   propagatedBuildInputs = (with self; [
  #     util-linux
  #   ]) ++ prev.propagatedBuildInputs;
  # });
  openlp = (((patch system).openlpFull).override{
    python3Packages = self.python3Packages.overrideScope(final: prev: {
      pyqt5 = prev.pyqt5.override{
        libsForQt5 = self.libsForQt5;
      };
    });
  }).overrideAttrs(final: prev: {
    LD_LIBRARY_PATH = prev.LD_LIBRARY_PATH + ":" + (lib.makeLibraryPath (with self; [
      curl
    ]));
  });
})