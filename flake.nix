{
  description = "flake for UnknownDevice-ux535";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      UnknownDevice_ux535 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/systems/specific/UnknownDevice_ux535.nix
        ];
      };
    };
  };
}