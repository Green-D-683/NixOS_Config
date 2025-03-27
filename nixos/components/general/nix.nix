{config, pkgs, lib, self, ...}:
{
  config = {
    nix = {
      package = pkgs.nixVersions.stable;
      settings = {
        auto-optimise-store = true;
        trusted-users = [
          "@wheel"
        ];
      };
      extraOptions = ''
        experimental-features = nix-command flakes
        warn-dirty = false
      '';
      registry = {
        nixpkgs = {
          from = {
            id = "nixpkgs";
            type = "indirect";
          };
          flake = self.inputs.nixpkgs;
        };
      };
    };
  };
}