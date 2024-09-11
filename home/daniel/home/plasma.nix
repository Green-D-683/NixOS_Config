{config, lib, ...}:
{
  programs.plasma = {
    enable = true;
    desktop = {
      mouseActions = {
        leftClick = "applicationLauncher";
        middleClick = "contextMenu";
        rightClick = "contextMenu";
        verticalScroll = "switchWindow";
      };
    };

    shortcuts = {

    };
  };
}