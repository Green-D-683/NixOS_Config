{pkgs, ...}:
{
  programs.plasma = {
    kscreenlocker = {
      lockOnResume = true;
      passwordRequired = true;
      passwordRequiredDelay = 0;
      timeout = 5;
      appearance ={
        wallpaper = "${pkgs.resources}/share/resources/lock.png";
        alwaysShowClock = true;
        showMediaControls = false; # Mitigate https://github.com/NixOS/nixpkgs/issues/442630
      };
    };
    workspace.splashScreen.theme = "None";
  };
}
