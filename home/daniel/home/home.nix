{cfg, pkgs, lib, ... }:

{
  imports = [
    ./plasma.nix
    ./programs.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home={
    username = lib.mkDefault "daniel";
    homeDirectory = lib.mkDefault "/home/daniel";

    # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.

    # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
    stateVersion = "23.11";

    shellAliases = {
      "neofetch" = "fastfetch";
    };
  };

  

  services = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdeConnect;
    };
  };
}