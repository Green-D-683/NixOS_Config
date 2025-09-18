{pkgs, inputs, ...}:
{
  config = {
    nix = {
      package = pkgs.nixVersions.stable;
      settings = {
        auto-optimise-store = true;
        trusted-users = [
          "@wheel"
        ];
        sandbox = true;
        extra-sandbox-paths = [ "/dev" "/sys" "/proc" ];
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
          flake = inputs.nixpkgs;
        };
      };
    };
  };
}
