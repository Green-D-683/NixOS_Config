{config, pkgs, ...}:

{
  config={
    environment.systemPackages = with pkgs; [
      ocaml
      opam
      ocamlPackages.utop
    ];
  };
}