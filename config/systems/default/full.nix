{config, pkgs, lib, ...}:
let 
  components = let path = ../../components/general; in [
    (path + "/base-config.nix")
    (path + "/graphical.nix")
    (path + "/networking.nix")
    (path + "/sound.nix")
    (path + "/bluetooth.nix")
    (path + "/printing.nix")
  ];
  programs = let path = ../../programs; in [
    (path + "/core.nix")
    (path + "/cad.nix")
    (path + "/devkit.nix")
    (path + "/gaming.nix")
  ];
  users = let path = ../../users; in [
    (path + "/daniel.nix")
  ];
in 

{
  imports = components ++ programs ++users;
}