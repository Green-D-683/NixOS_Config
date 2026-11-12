{
    self,
    lib,
    ...
}: let
    flakeHelpers = rec {
        pkgsForSys = system:
            import self.inputs.nixpkgs {
                system = system;
                overlays = [self.overlays.${system}];
                config = {
                    allowBroken = true;
                    allowUnfree = true;
                    permittedInsecurePackages = [
                        "qtwebkit-5.212.0-alpha4"
                        "electron-38.8.4"
                        "electron-39.8.10"
                        "ventoy-1.1.17"
                    ];
                    nvidia.acceptLicense = true;
                };
            };
        customNixosSystem = {
            system,
            configModule,
            extraModules ? [],
        }: (
            lib.nixosSystem rec {
                inherit system;
                pkgs = pkgsForSys system;
                inherit lib;
                modules =
                    [
                        self.nixosModules.default
                    ]
                    ++ (lib.optional (configModule != null) self.nixosModules.${configModule})
                    ++ extraModules
                    ++ (with self.inputs; [
                        home-manager.nixosModules.home-manager
                        sops-nix.nixosModules.sops
                    ]);
                specialArgs = {inherit self system; inputs = self.inputs;};
            }
        );

        nixosSystemAttr = spec: {
            ${spec.name} = customNixosSystem {
                system = spec.platform;
                configModule = spec.configModule;
                extraModules =
                    spec.extraModules
                    ++ [
                        {
                            environment.sessionVariables.NIXOS_SYSTEM_NAME = spec.name;
                        }
                    ];
            };
        };

        nixosSystemAttrs = systems: lib.attrListMerge (lib.lists.map nixosSystemAttr systems);
        nixosImageAttrs = images: lib.attrsets.concatMapAttrs (name: system: {${name} = system.config.system.build.sdImage;}) (nixosSystemAttrs images);
        nixosInstallerAttrs = systems: lib.attrsets.concatMapAttrs (name: system: {${name} = system.config.system.build.isoImage;}) (nixosSystemAttrs systems);

        findNixOSModules = dir:
            lib.attrListMerge (
                lib.lists.map (dir: {
                    ${lib.dirOps.getParentName dir} = (
                        {...}: {
                            imports = lib.getDirRec dir;
                        }
                    );
                }) (lib.dirOps.findDirRec "nixosModule" dir)
            );

        findNixOSSystems = dir: (
            builtins.map (systemDir: import "${systemDir.dir}/host.nix" {inherit self;} // {configModule = systemDir.name;})
            (builtins.map (file: {name = lib.dirOps.getParentName file; dir = lib.dirOps.getParent file;}) (lib.findFileRec "host.nix" dir))
        );

        findNixOSImages = dir: (
            let
                systems = findNixOSSystems dir;
                getArch = platform: builtins.head (lib.strings.splitString "-" platform);
            in
                builtins.map (
                    spec:
                        lib.mergeAttrsRecComb spec {
                            extraModules = [
                                "${self.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-${getArch spec.platform}.nix"
                                ({...}: {sdImage.compressImage = false;})
                            ];
                        }
                )
                systems
        );

        nixOSIsoSpec = {
            platform,
            isoModule,
        }: {
            name = platform;
            inherit platform;
            extraModules = [
                "${self.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
                isoModule
            ];
            configModule = null; # ISO specific basic config - single user, minimal packages
        };

        buildNixOSSystems = dir: nixosSystemAttrs (findNixOSSystems dir);

        buildNixOSImages = dir: nixosImageAttrs (findNixOSImages dir);

        buildNixOSInstallers = isoModule: platforms:
            nixosInstallerAttrs (
                lib.lists.map
                (platform: nixOSIsoSpec {inherit platform isoModule;})
                platforms
            );
    };
in
    {
        inherit flakeHelpers;
    }
    // flakeHelpers
