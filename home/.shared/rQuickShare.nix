{config, pkgs, lib, ...}:
{
  options.programs.rquickshare.enable = lib.mkEnableOption "rQuickShare";

  config = lib.mkIf config.programs.rquickshare.enable {
    home.packages = [ pkgs.rquickshare ];
    home.file.".local/share/dev.mandre.rquickshare/.settings.json" = {
      enable = true;
      text = ''
      {
        "realclose": false,
        "autostart": true,
        "startminimized": true,
        "download_path": "/home/daniel/Downloads/QuickShare",
        "visibility": 0,
        "port": 49999 
      }
      '';
      force = true;
    };
  };
}