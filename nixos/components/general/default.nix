{config, pkgs, lib, ...}:
let
getContents = dir : builtins.attrValues (builtins.mapAttrs (name: _: ./. + "/${name}") (lob.attrsets.filterAttrs (name: _: (lib.hasSuffix ".nix" name) && !(name == "default.nix")) (builtins.readDir dir)));
in
{
  imports = getContents(./.);
}