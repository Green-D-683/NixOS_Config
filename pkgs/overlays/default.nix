{
    inputs,
    system,
    lib,
    self,
}:
lib.importDirRec ./. {inherit inputs system self lib;}
