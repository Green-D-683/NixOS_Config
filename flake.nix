{
  description = "flake for UnknownDevice-ux535";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-utils={
      url = github:numtide/flake-utils;
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      UnknownDevice_ux535 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/systems/specific/ux535/config.nix
        ];
      };
      Shells_ux535 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/systems/default/minimal.nix
          ./config/programs/development
          ./config/systems/specific/ux535/hardware-configuration.nix
        ];
      };
    };
    devShells."x86_64-linux" = let
    utils = inputs.flake-utils.lib;
    system = "x86_64-linux"; 
    pkgs = import inputs.nixpkgs {inherit system;};
    in 
    {
      python = pkgs.mkShell {
          modules = [
            ./config/programs/development/python.nix
          ];
      };
      java = pkgs.mkShell {
          modules = [
            ./config/programs/development/java.nix
          ];
      };
      ocaml = pkgs.mkShell {
          modules = [
            ./config/programs/development/ocaml.nix
          ];
      };
      sql = pkgs.mkShell {
          modules = [
            ./config/programs/development/sql.nix
          ];
      };
    };
  };
}