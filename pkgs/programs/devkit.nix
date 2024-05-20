{pkgs, ...}:

let
l = (x: pkgs.writeScriptBin "${x}_shell" "nix develop github:Lordraven19/NixOS_Config#${x} --no-write-lock-file");
commandA = "nix develop github:Lordraven19/NixOS_Config#";
commandB  = " --no-write-lock-file";
pyShell = pkgs.writeScriptBin "python_shell" "${commandA}python${commandB}";
javaShell = pkgs.writeScriptBin "java_shell" "${commandA}java${commandB}";
sqlShell = pkgs.writeScriptBin "sql_shell" "${commandA}sql${commandB}";
ocamlShell = pkgs.writeScriptBin "ocaml_shell" "${commandA}ocaml${commandB}";
scripts = [pyShell javaShell sqlShell ocamlShell];
in
with pkgs; [
  vscode # Included in core.nix
  powershell
  github-desktop
  android-tools
  universal-android-debloater
] ++ scripts