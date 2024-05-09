{pkgs, ...}:

with pkgs; [
  jdk20
  scenic-view
  maven
  scenebuilder
]

# {
#   config={
#     environment.systemPackages = with pkgs; [
#       jdk20
#     ];

#     # programs.java = { enable = true; package = pkgs.jdk20; };
#   };
# }