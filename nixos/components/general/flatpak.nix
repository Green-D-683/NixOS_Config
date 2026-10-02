{pkgs, lib, config, ...}:
{
  options.systemConfig.niceties.enableFlatpak = lib.mkEnableOption "Enable Flatpak on this Host";

  config = lib.mkIf (config.systemConfig.niceties.enableFlatpak) {
    systemd.services.flatpak-flathub-repo = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      script = ''
        ${lib.getExe pkgs.flatpak} remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      '';
    };
    services.flatpak.enable = true;
  };
}
