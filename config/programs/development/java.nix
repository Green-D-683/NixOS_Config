{config, pkgs, ...}:

{
  config={
    environment.systemPackages = with pkgs; [
      jdk20
    ];

    programs.java = { enable = true; package = pkgs.jdk20; };
  };
}