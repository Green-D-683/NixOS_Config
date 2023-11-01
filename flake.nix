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
          buildInputs = let pyLibs = ps: with ps; [
            pip
            dill
            pygame
            tkinter
            (
              buildPythonPackage rec {
                pname = "guizero";
                version = "1.4.0";
                src = fetchPypi {
                  inherit pname version;
                  sha256 = "sha256-V2TjijsqCJcS7B51NAv4M16nch43342QIc3Qr7i1eic=";
                };
                doCheck = false;
                propagatedBuildInputs = [
                  ## Specify dependencies
                  # pkgs.python3Packages.tkinter
                  # pkgs.python3Full
                ];
              }
            )]; in 
            with pkgs; [(python3Full.withPackages pyLibs)];
      };
      java = pkgs.mkShell {
          buildInputs = [
            pkgs.jdk20
          ];
      };
      ocaml = pkgs.mkShell {
          buildInputs = with pkgs; [
            ocaml
            opam
            ocamlPackages.utop
          ];
      };
      sql = pkgs.mkShell {
          buildInputs = with pkgs;[
            (python3.withPackages (ps: with ps; [pip tinydb]))
            sqlite
            neo4j
          ];
      };
    };
  };
}