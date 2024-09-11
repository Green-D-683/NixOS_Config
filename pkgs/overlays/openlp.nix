{inputs, system, ...}:
let patch = (system: inputs.nixpkgs-openlp.legacyPackages.${system});
in
(self: super: {
  openlp = (patch system).openlp;
  openlpFull = (patch system).openlpFull;
})