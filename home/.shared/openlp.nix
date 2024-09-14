{config, lib, ...}:
{
  programs.plasma = lib.mkIf (builtins.elem "ciccu" config.userModule.install-lists){
    window-rules = {
      "LibreOffice-Impress-Presentations"={
        description = "LibreOffice Impress Presentation View";
        match = {
          window-class = {
            match-whole = true;
            type = "exact";
            value = "soffice.bin libreoffice-impress";
          };
          title = {
            type = "substring";
            value = "Presenting:";
          };
          window-types = [
            "desktop" "dialog" "dock" "menubar" "normal" "osd" "spash" "toolbar" "torn-of-menu" "utility"
          ];
        };
        apply = {
          "screen" = {
            apply = "force";
            value = 1;
          };
          "fullscreen" = {
            apply = "force";
            value = true;
          };
          "above" = {
            apply = "force";
            value = true;
          };
          "skiptaskbar" = {
            apply = "force";
            value = true;
          };
          "skippager" = {
            apply = "force";
            value = true;
          };
          "skipswitcher" = {
            apply = "force";
            value = true;
          };
          "noborder" = {
            apply = "force";
            value = true;
          };
        };
      };
    };
  };

  xdg.desktopEntries = {
    openlp = {
      type = "Application";
      exec = "steam-run openlp";
      name = "OpenLP";
      icon = "view-presentation";
    };
  };
}