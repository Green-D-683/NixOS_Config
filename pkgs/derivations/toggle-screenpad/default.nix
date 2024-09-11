{pkgs, ...}:
let 
name = "toggle-screenpad";
runtimeDeps = with pkgs; [
  kdePackages.libkscreen
  gnused
  python3Minimal
  gnugrep
  coreutils
];
script = (pkgs.writeScriptBin "${name}" (builtins.readFile ./${name}.sh)).overrideAttrs(old: {
  buildCommand = "${old.buildCommand}\n patchShebangs $out";
});
in
pkgs.symlinkJoin {
  inherit name;
  paths = [script] ++ runtimeDeps;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
}