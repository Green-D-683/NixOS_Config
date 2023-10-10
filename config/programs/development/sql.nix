{config, pkgs, ...}:

let pyLibs = ps: with ps;[
  pip
  tinydb
];
in

{
  config={
    environment.systemPackages = with pkgs; [
      vscode # Included in core.nix
      # Python
      (python3.withPackages pyLibs)
      sqlite
      neo4j
    ];
  };
}