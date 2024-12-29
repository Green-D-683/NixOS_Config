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
      url = "github:nix-community/plasma-manager";
      # url = "github:Green-D-683/plasma-manager/PowerDevil-Additions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware = {
      # url = "github:Green-D-683/nixos-hardware/ux535"; # Temporary until PR merged
      url = "github:NixOS/nixos-hardware/master";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    vscode-server={
      url = "github:nix-community/nixos-vscode-server";
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager, nixpkgs-openlp, flake-utils, screenpad-driver, plasma-manager, nixos-hardware, nix-on-droid, ...}: 
    let
      mylib = import ./lib {inherit self; lib = nixpkgs.lib;};
      lib = nixpkgs.lib.extend (
        final: prev: self.lib // home-manager.lib
      );
      overlays = (system: import ./pkgs/overlays {inherit inputs; inherit system; lib = lib; inherit self;});
      pkgsForSys = (system: import inputs.nixpkgs {
        system = system;
        overlays = (self.overlays.${system}.default);
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
    nixosConfigurations = let nixosSystem = {system, configPath}: (
        inputs.nixpkgs.lib.nixosSystem rec {
          inherit system;
          pkgs = pkgsForSys system;
          inherit lib;
          modules = [
            ./nixos/systems/default
            "./nixos/systems/specific/${configPath}"
          ];
          specialArgs = {inherit inputs self;};
          }
        ); in {
      UnknownDevice_ux535 = nixosSystem {
        system = "x86_64-linux";
        configPath = "ux535/config.nix";
      };
      UnknownDevice_b50-10 = nixosSystem {
        system = "x86_64-linux";
        configPath = "b50-10/config.nix";
      };
      UnknownPi4 = nixosSystem {
        system = "aarch64-linux";
        configPath = "Pi4/config.nix";
      };
    };
    homeConfigurations = let
      _daniel= system: home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSys system;
        #system = "x86_64-linux";
        modules = [
          ./home/daniel/home/home.nix
          #self.homeManagerModules.shared
        ];
        extraSpecialArgs = {inherit inputs;};
      }; in {
      daniel-x86_64-linux = _daniel "x86_64-linux";
      daniel-aarch64-linux = _daniel "aarch64-linux";
    };
    homeManagerModules = {
      shared = {...}:{
        imports = [./home/.shared];
      };
      rclone = {...}:{
        imports = [./home/.shared/rclone.nix];
      };
      daniel = {...}:{
        imports = [./home/daniel/home/home.nix];
      };
    };

    packageListNames = (lib.getDirNamesOnly ./pkgs/programs);

    lib = mylib;

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = pkgsForSys "aarch64-linux";
      modules = [ ./nix-on-droid ];
      extraSpecialArgs = {
        inherit self lib inputs;
      };
    };
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
      
      overlays.default = overlays system;
      
      packages = let
        package = name: {${name} = import ./pkgs/derivations/${name} {inherit pkgs; lib = self.lib;};};
        in lib.attrListMerge (builtins.map package (lib.getSubDirNames ./pkgs/derivations));
    });
}