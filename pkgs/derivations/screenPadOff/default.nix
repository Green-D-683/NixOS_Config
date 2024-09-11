{pkgs, ...}:
let 
name = "screenPadOff";
runtimeDeps = with pkgs; [
  kdePackages.libkscreen
  gnused
  gnugrep
  coreutils
  python3Minimal
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