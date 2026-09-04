{...}:
{
  pkgScript = {pkgs, name, scriptFile, runtimeDeps} : let
    script = (pkgs.writeScriptBin "${name}" (builtins.readFile scriptFile)).overrideAttrs(old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });
    in pkgs.symlinkJoin {
      inherit name;
      paths = [script] ++ runtimeDeps;
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
    };
}