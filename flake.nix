{
  description = "flake for UnknownDevice-ux535";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-openlp = {
      url = "github:Green-D-683/nixpkgs/openlp";
    };
    flake-utils={
      url = "github:numtide/flake-utils";
    };
    home-manager={
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    screenpad-driver={
      url = "github:MatthewCash/asus-wmi-screenpad-module";
      inputs.nixpkgs.follows="nixpkgs";
    };
    plasma-manager = {
      # url = "github:nix-community/plasma-manager";
      url = "github:Green-D-683/plasma-manager/patch-1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware = {
      url = "github:Green-D-683/nixos-hardware/ux535"; # Temporary until PR merged
      # url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager, nixpkgs-openlp, flake-utils, screenpad-driver, plasma-manager, nixos-hardware, ...}: 
    let
      mylib = import ./lib {inherit self; lib = nixpkgs.lib;};
      lib = nixpkgs.lib.extend (
        final: prev: self.lib // home-manager.lib
      );
      overlays = (system: import ./pkgs/overlays {inherit inputs; inherit system; lib = lib; inherit self;});
      pkgsForSys = (system: import inputs.nixpkgs {
        system = system;
        overlays = (self.overlays.default system);
        config = {
          allowBroken = true;
          allowUnfree = true;
          permittedInsecurePackages = [
            "qtwebkit-5.212.0-alpha4"
            "electron-28.3.3"
            "electron-27.3.11"
          ];
        };
      });
    in
    {
    nixosConfigurations = {
      UnknownDevice_ux535 = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        inherit lib;
        pkgs = pkgsForSys system;
        modules = [
          ./nixos/systems/specific/ux535/config.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
                #self.homeManagerModules.shared
              ];
              backupFileExtension="backup";
            };
          }
        ];
        specialArgs = {inherit inputs system self;};
      };
    };
    homeConfigurations = {
      daniel=home-manager.lib.homeManagerConfiguration rec {
        pkgs = pkgsForSys system;
        system = "x86_64-linux";
        modules = [
          ./home/daniel/home/home.nix
        ];
        extraSpecialArgs = {inherit inputs;};
      };
    };
    homeManagerModules = {
      shared = {...}:{
        imports = [./home/.shared];
      };
    };

    packageListNames = (lib.getDirNamesOnly ./pkgs/programs);

    overlays = {
      default = overlays;
    };
    lib = mylib;
    } // 
    flake-utils.lib.eachDefaultSystem (system: 
    let 
      pkgs = pkgsForSys system;
    in {
    devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nil
          ];
        };
      };
      
      packages = let
        package = name: {${name} = import ./pkgs/derivations/${name} {inherit pkgs;};};
        in lib.attrListMerge (builtins.map package (lib.getSubDirNames ./pkgs/derivations));
    });
}