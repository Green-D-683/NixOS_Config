{pkgs, lib, ...}:

lib.lists.flatten(map (x : import ./${x}.nix {pkgs=pkgs; lib=lib;}) [
  "java"
  "ocaml"
  "python"
  "sql"
])