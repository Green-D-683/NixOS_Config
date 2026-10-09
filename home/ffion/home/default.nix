{withSecrets ? true}:
{lib, pkgs, ...}:
{
    imports = lib.getDirRec ./. withSecrets;

    config = {
        home={
          username = lib.mkDefault "ffion";
          homeDirectory = lib.mkDefault "/home/ffion";

          # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.

          # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
          stateVersion = "23.11";

          packages = with pkgs; [ appmenu-gtk-wayland ];

          sessionVariables = {
            # Tells GTK to load the module at startup
            GTK_MODULES = "appmenu-gtk-module";
            # Ensures the desktop bridge registers properly
            UBUNTU_MENUPROXY = "1";
          };
        };
    };
}
