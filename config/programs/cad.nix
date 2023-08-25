{config, pkgs, ...}:

{
  config={
    environment.systemPackages= with pkgs; [
      freecad
    ];
  };
}