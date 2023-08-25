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
  ];
  users = let path = ../../users; in [
    (path + "/daniel.nix")
  ];
{
  imports = components ++ programs ++ users;
}