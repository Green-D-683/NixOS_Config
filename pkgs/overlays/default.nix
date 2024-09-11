{inputs, system, lib} :
lib.importDir ./. {inherit inputs; inherit system;}