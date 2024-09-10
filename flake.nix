{
  description = "flake for UnknownDevice-ux535";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-openlp = {
      url = "github:jorsn/nixpkgs/openlp";
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager, nixpkgs-openlp, flake-utils, screenpad-driver, plasma-manager, nixos-hardware, ...}: 
    let 
      lib = nixpkgs.lib.extend (
        # self: super: {custom = (import ./lib {lib = self;});} // home-manager.lib
        self: super: (import ./lib nixpkgs.lib) // home-manager.lib
      );
      overlays = (system: import ./pkgs/overlays {inherit inputs; inherit system; lib = lib;});

      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86-64-darwin"
      ];
      linux = builtins.filter (x: nixpkgs.lib.strings.hasInfix "linux" x) systems;
      darwin = builtins.filter (x: nixpkgs.lib.strings.hasInfix "darwin" x) systems;
      forAllSystems = nixpkgs.lib.genAttrs systems;
      forAllLinux = nixpkgs.lib.genAttrs linux;
      forAllDarwin = nixpkgs.lib.genAttrs darwin;
      pkgsForSys = (system: import inputs.nixpkgs {
        system = system;
        overlays = overlays system;
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

      home = user: import ./home/${user}/home/home.nix;

    # in flake-utils.lib.eachSystem systems (system: rec {
    #   legacyPackages = pkgsForSys system;
    # }) // {
    #   nixosModules.home = home "daniel";
    # }
    in
    {
    nixosConfigurations = {
      UnknownDevice_ux535 = inputs.nixpkgs.lib.nixosSystem rec {
        pkgs = pkgsForSys system;
        system = "x86_64-linux";
        inherit lib;
        modules = [
          ./nixos/systems/specific/ux535/config.nix
          home-manager.nixosModules.home-manager
          #{home-manager.users.daniel = home "daniel";}
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
              ];
              backupFileExtension="backup";
              users.daniel = import ./home/daniel/home/home.nix {pkgs = pkgsForSys system; lib = lib;};
            };
          }
        ];
        specialArgs = {inherit inputs;};

      };
      Shells_ux535 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/systems/default/minimal.nix
          ./pkgs/programs/development
          ./nixos/systems/specific/ux535/hardware-configuration.nix
        ];
      };
    };
    homeConfigurations = {
      daniel=home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSys "x86_64-linux";
        modules = [
          # (
          #   {nixpkgs.overlays = overlays;}
          # )
          ./home/daniel/home/home.nix
        ];
        extraSpecialArgs = {inherit inputs;};
      };
    };
    devShells."x86_64-linux" = let
      utils = inputs.flake-utils.lib;
      system = "x86_64-linux"; 
      pkgs = import inputs.nixpkgs {
        inherit system; 
        overlays = self.overlays.default system;
      };
      in 
      {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nil
          ];
        };

        python = pkgs.mkShell {
            buildInputs = import ./pkgs/programs/development/python.nix;
        };
        java = pkgs.mkShell {
            buildInputs = import ./pkgs/programs/development/java.nix;
        };
        ocaml = pkgs.mkShell {
            buildInputs = import ./pkgs/programs/development/ocaml.nix;
        };
        sql = pkgs.mkShell {
            buildInputs = import ./pkgs/programs/development/sql.nix;
        };
      };
      overlays = {
        default = overlays;
      };
    };
}