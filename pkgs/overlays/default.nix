{inputs, system, lib, self} :
lib.importDir ./. {inherit inputs; inherit system; inherit self;}