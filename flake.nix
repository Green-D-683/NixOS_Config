{
  description = "flake for UnknownDevice-ux535";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    flake-utils={
      url = github:numtide/flake-utils;
    };
    home-manager={
      url = "github:nix-community/home-manager";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{nixpkgs, home-manager, nixpkgs-stable,...}: 
    let 
      overlays = import ./pkgs/overlays.nix {inherit nixpkgs-stable; pkgs = nixpkgs;};
      # nixpkgs = (inputs: {
      #   nixpkgs = {
      #     config = {
      #       allowUnfree = true;
      #       allowBroken = true;
      #     };
      #     overlays = overlays;
      #   };
      # });
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
        overlays = overlays;
        system = system;
        config = {
          allowBroken = true;
          allowUnfree = true;
          permittedInsecurePackages = [
            "qtwebkit-5.212.0-alpha4"
          ];
        };
      });

    in
    {
    nixosConfigurations = {
      UnknownDevice_ux535 = inputs.nixpkgs.lib.nixosSystem rec {
        pkgs = pkgsForSys system;
        system = "x86_64-linux";
        modules = [
          ./nixos/systems/specific/ux535/config.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.daniel = import ./home/daniel/home/home.nix {pkgs = pkgsForSys system; lib = pkgs.lib; nixpkgs-stable=nixpkgs-stable; };
            };
          }
        ];

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
        overlays = import ./pkgs/overlays.nix;
      };
      in 
      {
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
    };
}