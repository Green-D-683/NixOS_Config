{ pkgs, inputs, ... }:

{
  #services.nix-daemon.enable = true;

  environment.defaultPackages = with pkgs; [
    zed-editor
    git
    git-crypt
  ];

  system.stateVersion = 6;

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    #nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
