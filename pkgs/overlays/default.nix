{inputs, system} :
let 
pkgs = import inputs.nixpkgs {inherit system;};
lib = pkgs.lib;
getContents = dir : builtins.attrValues (builtins.mapAttrs (name: _: ./. + "/${name}") (lib.attrsets.filterAttrs (name: _: (lib.hasSuffix ".nix" name) && !(name == "default.nix")) (builtins.readDir dir)));
in
(
  builtins.map (f: import f {inherit inputs; inherit system;}) (getContents(./.))
)