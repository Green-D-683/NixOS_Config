{
  description = "flake for Green-D-683's NixOS and NixOS-related devices";

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
      # Build lib of all nix functions - nixpkgs, home-manager and my custom functions, found in ./lib
      lib = nixpkgs.lib.extend (
        _: _: self.lib // home-manager.lib
      );

      # Define each system to be declared in nixosConfigurations here:
      systems = [
        # {
        #   name = "< name of attrset value >";
        #   platform = "< platform of system - some kind of linux >";
        #   configModule = "< nixosModule to import with system-specific configuration >";
        #   extraModules = []; # Any extra modules to import - probably should be imported in the specified nixosModule instead
        # }
        {
          name = "UnknownDevice_ux535";
          platform = "x86_64-linux";
          configModule = "ux535";
          extraModules = [];
        }
        {
          name = "UnknownDevice_b50-10";
          platform = "x86_64-linux";
          configModule = "b50-10";
          extraModules = [];
        }
        {
          name = "UnknownPi4";
          platform = "aarch64-linux";
          configModule = "Pi4";
          extraModules = [];
        }
      ];

      # Build disk images for each of the systems specified above - for direct building and installation - these may be large and take a long time to build
      images = lib.lists.map (spec: spec // {
        extraModules = let
          arch = builtins.elemAt (lib.strings.splitString "-" spec.platform) 0;
        in [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-${arch}.nix"
          ({...}:{sdImage.compressImage = false;})
          ];
      }) systems;

      # Build an install media for each linux arch
      installers = lib.lists.map (platform: {
        name = platform;
        inherit platform;
        extraModules =[
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ];
        configModule = "iso"; # ISO specific basic config - single user, minimal packages
      }) [ "aarch64-linux" "x86_64-linux" "i686-linux" ];

    in
    {
    nixosConfigurations = lib.nixosSystemAttrs systems;
    nixosImages = lib.nixosImageAttrs images;
    nixosInstallers = lib.nixosInstallerAttrs installers;
    nixosModules = (
      {
        # Default Module containing all configuration found in ./nixos/components
        default = ({...}:{imports = [
          ./nixos/components/default.nix
          ./home/default.nix
        ];});
      } //
      # Create a module for each specific system to be defined - each dir in ./nixos/systems/${dir} is a computer I want a configuration for, exclusing hidden directories (starting with `.`)
      lib.attrListMerge (
        lib.lists.map (dir: {
          ${dir}=({...}:
            {
              imports = [
                ./nixos/systems/${dir}
              ];
            }
          );
        }) (lib.getSubDirNames ./nixos/systems)));

    homeConfigurations = let
      # Define common home-manager import and then specify arch below
      _daniel= system: home-manager.lib.homeManagerConfiguration {
        pkgs = lib.pkgsForSys system;
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
      # Common configuration shared by all users
      shared = {...}:{
        imports = [./home/.shared];
      };
      # Sets up a systemd service to automatically mount configured rclone remotes when network online
      rclone = {...}:{
        imports = [./home/.shared/rclone.nix];
      };
      # User configuration for daniel
      daniel = {...}:{
        imports = [./home/daniel/home/home.nix];
      };
    };

    packageListNames = (lib.getDirNamesOnly ./pkgs/programs);

    lib = import ./lib {inherit self; lib = nixpkgs.lib;};

    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = lib.pkgsForSys "aarch64-linux";
      modules = [ ./nix-on-droid ];
      extraSpecialArgs = {
        inherit self lib inputs;
      };
    };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = lib.pkgsForSys system;
      in {
      devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              nixd
            ];
          };
        };

      overlays = final: prev: lib.attrListMerge (lib.lists.map (overlay: overlay final prev) (import ./pkgs/overlays {inherit inputs; inherit system; lib = lib; inherit self;}));

      packages = let
        package = name: {${name} = import ./pkgs/derivations/${name} {inherit pkgs; lib = self.lib;};};
        in lib.attrListMerge (builtins.map package (lib.getSubDirNames ./pkgs/derivations));
    });
}
