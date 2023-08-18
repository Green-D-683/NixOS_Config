{config, pkgs, lib}:

{
  config={
    # # needed for store VS Code auth token 
    # services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      # vscode # Included in core.nix
      # Python
      python3Full
      python310Packages.pip
    ]
  };
}