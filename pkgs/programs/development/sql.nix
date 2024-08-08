{pkgs, ...}:

let pyLibs = ps: with ps;[
  pip
  tinydb
];
in
with pkgs; [
  #vscode.fhs # Included in core.nix
  # Python
  # ((python3.withPackages pyLibs).override (args: { ignoreCollisions = true; }))
  sqlite
  neo4j
]