{config, lib, ...}:
{
  programs.plasma = lib.mkIf (builtins.elem "ciccu" config.userModule.install-lists){
    window-rules = [
      {
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
          "position" = {
            apply = "force";
            value = "1920,0";
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
      }
      {
        description = "VLC Player for OpenLP";
        match = {
          window-class = {
            match-whole = false;
            type = "exact";
            value = "Vlc";
          };
          # title = {
          #   type = "substring";
          #   value = "Presenting:";
          # };
          window-role = {
            type = "exact";
            value = "vlc-video";
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
          "position" = {
            apply = "force";
            value = "1920,0";
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
      }
      {
        description = "OpenLP Controller Window";
        match = {
          window-class = {
            match-whole = false;
            type = "exact";
            value = "openlp";
          };
          title = {
            type = "substring";
            value = "OpenLP";
          };
          # window-role = {
          #   type = "exact";
          #   value = "vlc-video";
          # };
          window-types = [
            "desktop" "dialog" "dock" "menubar" "normal" "osd" "spash" "toolbar" "torn-of-menu" "utility"
          ];
        };
        apply = {
          "screen" = {
            apply = "force";
            value = 0;
          };
          "position" = {
            apply = "force";
            value = "0,0";
          };
          "fullscreen" = {
            apply = "force";
            value = false;
          };
          "below" = {
            apply = "force";
            value = false;
          };
          "skiptaskbar" = {
            apply = "force";
            value = false;
          };
          "skippager" = {
            apply = "force";
            value = false;
          };
          "skipswitcher" = {
            apply = "force";
            value = false;
          };
          "noborder" = {
            apply = "force";
            value = false;
          };
          "desktopfile" = {
            apply = "force";
            value = "openlp";
          };
        };
      }
      {
        description = "OpenLP Projection - Projector";
        match = {
          window-class = {
            match-whole = false;
            type = "exact";
            value = "openlp";
          };
          title = {
            type = "exact";
            value = "Display Window";
          };
          # window-role = {
          #   type = "exact";
          #   value = "vlc-video";
          # };
          window-types = [
            "desktop" "dialog" "dock" "menubar" "normal" "osd" "spash" "toolbar" "torn-of-menu" "utility"
          ];
        };
        apply = {
          "screen" = {
            apply = "force";
            value = 1;
          };
          "position" = {
            apply = "force";
            value = "1920,0";
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
      }
      {
        description = "OpenLP Projection - ScreenPad";
        match = {
          window-class = {
            match-whole = false;
            type = "exact";
            value = "openlp";
          };
          title = {
            type = "exact";
            value = "Display Window";
          };
          # window-role = {
          #   type = "exact";
          #   value = "vlc-video";
          # };
          window-types = [
            "desktop" "dialog" "dock" "menubar" "normal" "osd" "spash" "toolbar" "torn-of-menu" "utility"
          ];
        };
        apply = {
          "screen" = {
            apply = "force";
            value = 1;
          };
          "position" = {
            apply = "force";
            value = "420,1080";
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
      }
      {
        description = "OpenLP Video - Projector";
        match = {
          window-class = {
            match-whole = false;
            type = "exact";
            value = "openlp";
          };
          title = {
            type = "exact";
            value = "OpenLP";
          };
          # window-role = {
          #   type = "exact";
          #   value = "vlc-video";
          # };
          window-types = [
            "desktop" "dialog" "dock" "menubar" "normal" "osd" "spash" "toolbar" "torn-of-menu" "utility"
          ];
        };
        apply = {
          "screen" = {
            apply = "force";
            value = 1;
          };
          "position" = {
            apply = "force";
            value = "1920,0";
          };
          "fullscreen" = {
            apply = "force";
            value = true;
          };
          "below" = {
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
      }
      {
        description = "OpenLP Video - ScreenPad";
        match = {
          window-class = {
            match-whole = false;
            type = "exact";
            value = "openlp";
          };
          title = {
            type = "exact";
            value = "OpenLP";
          };
          # window-role = {
          #   type = "exact";
          #   value = "vlc-video";
          # };
          window-types = [
            "desktop" "dialog" "dock" "menubar" "normal" "osd" "spash" "toolbar" "torn-of-menu" "utility"
          ];
        };
        apply = {
          "screen" = {
            apply = "force";
            value = 1;
          };
          "position" = {
            apply = "force";
            value = "420,1080";
          };
          "fullscreen" = {
            apply = "force";
            value = true;
          };
          "below" = {
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
      }
    ];
  };

  xdg.desktopEntries = {
    openlp = {
      type = "Application";
      exec = "openlp";
      name = "OpenLP";
      icon = "view-presentation";
    };
  };
}