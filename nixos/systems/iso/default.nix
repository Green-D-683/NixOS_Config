{...}:
{
  config = {
    systemConfig = {
      laptop = true; # Assume lower-power device by default
      hostname = "UnknownDevice-Installer";
    };
    userConfig = {
      users = [
        "daniel"
      ];
      userModules = {
        daniel = {
          install-lists = [
            "core_utils"
            "devkit"
            "general"
            "core_gui"
          ];
        };
      };
    };
  };

}