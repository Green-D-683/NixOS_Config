{pkgs, ...}:

with pkgs; [
  (pkgs.callPackage ../derivations/openlp {})
]