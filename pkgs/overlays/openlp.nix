{inputs, system, ...}:
let patch = (system: inputs.nixpkgs-openlp.legacyPackages.${system});
in
(self: super: {
  openlp = ((patch system).openlp).overrideAttrs( final: prev:{
    propagatedBuildInputs = prev.propagatedBuildInputs ++ (with self; [
      python3Packages.pyqt6
      util-linux
      libstdcxx5
    ]);
  });
  openlpFull = ((patch system).openlpFull).overrideAttrs( final: prev:{
    propagatedBuildInputs = prev.propagatedBuildInputs ++ (with self; [
      python3Packages.pyqt6
      util-linux
      libstdcxx5
    ]);
  });
})