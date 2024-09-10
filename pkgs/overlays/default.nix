{inputs, system, lib} :
lib.importDirRec ./. {inherit inputs; inherit system;}