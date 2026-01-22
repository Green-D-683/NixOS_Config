{self, lib, ...}: rec
{
  pkgsForSys = (system: import self.inputs.nixpkgs {
    system = system;
    overlays = [self.overlays.${system}];
    config = {
      allowBroken = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "qtwebkit-5.212.0-alpha4"
        "electron-28.3.3"
        "electron-27.3.11"
        "ventoy-1.1.10"
      ];
    };
  });
  customNixosSystem = {system, configModule, extraModules ? []}: (
    lib.nixosSystem rec {
      inherit system;
      pkgs = pkgsForSys system;
      inherit lib;
      modules = [
        self.nixosModules.default
        self.nixosModules.${configModule}
      ] ++ extraModules;
      specialArgs = {inherit self system; inputs = self.inputs;};
    }
  );

  nixosSystemAttr = (spec: {
    ${spec.name} = customNixosSystem {
      system = spec.platform;
      configModule = spec.configModule;
      extraModules = spec.extraModules ++ [{
        environment.sessionVariables.NIXOS_SYSTEM_NAME = spec.name;
      }];
    };
  });

  nixosSystemAttrs = (systems: lib.attrListMerge (lib.lists.map nixosSystemAttr systems));
  nixosImageAttrs = (images: lib.attrsets.concatMapAttrs (name: system: {${name} = system.config.system.build.sdImage;}) (nixosSystemAttrs images));
  nixosInstallerAttrs = (systems: lib.attrsets.concatMapAttrs (name: system: {${name} = system.config.system.build.isoImage;}) (nixosSystemAttrs systems));
}
