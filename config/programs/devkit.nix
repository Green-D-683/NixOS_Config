{config, pkgs, ...}:

let 
commandA = "nix develop github:Lordraven19/NixOSConfig#";
commandB  = " --no-write-lock-file";
pyShell = pkgs.writeScriptBin "python_shell" "${commandA}python${commandB}";
javaShell = pkgs.writeScriptBin "java_shell" "${commandA}java${commandB}";
sqlShell = pkgs.writeScriptBin "sql_shell" "${commandA}sql${commandB}";
ocamlShell = pkgs.writeScriptBin "ocaml_shell" "${commandA}ocaml${commandB}";
scripts = [pyShell javaShell sqlShell ocaml_shell];
in

{
  config={
    # # needed for store VS Code auth token 
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      vscode # Included in core.nix
      powershell
    ] ++ scripts;
  };
}