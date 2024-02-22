{pkgs, ...}:

with pkgs; [jdk20]

# {
#   config={
#     environment.systemPackages = with pkgs; [
#       jdk20
#     ];

#     # programs.java = { enable = true; package = pkgs.jdk20; };
#   };
# }