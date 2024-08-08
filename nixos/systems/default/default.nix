{config, pkgs, lib, ...}:

{
  imports = [
    ../../components/general
    ../../../home
  ];

  options = {
    userConfig = {
      users = lib.mkOption{
        default = ["daniel"];
        type = with types; listOf emum [];
        description = "The users to include for the device";
      };
    };

    systemConfig={

      ## Power Optimisations - This also can enable graphics by default for Desktops and Laptops
      laptop = lib.mkEnableOption "Laptop Optimisations";
      desktop = lib.mkEnableOption "Desktop Optimisations";
      optimiseFor = lib.mkOption{ # Handles Mutual Exclusivity - not for direct use
        default = "";
        type = types.enum ["" "laptop" "desktop"];
        visible = false;
      };

      ## Graphical User Environment
      graphicalEnv = lib.mkEnableOption "Graphical User Interface";
      gpu = lib.mkOption{
        default = "";
        type = types.enum ["" "intel" "nvidia" "amd"]
      };

      ## Common Hardware
      extraHardware = lib.mkOption{
        default = [];
        type = with types; listOf (enum [
          "thunderbolt"
          "screenpad"
          "asus-battery"
          "displaylink"
        ]);
        description = "Extra Hardware Devices specific to this system, to be added to the configuration";
      };

      ## Network Hostname
      hostname = mkOption{
        default = "UnknownDevice";
        type = types.str;
        description = "Hostname for Network connections";
      };

      ## Any Extra Config not Covered by Generic Modules
      specialConfig = lib.mkOption {
        type = types.anything;
      };
    };
  };

  config = lib.mkMerge [
    ({systemConfig = lib.mkMerge [
      (lib.mkIf (config.systemConfig.laptop) {
        optimiseFor = "laptop";
        graphicalEnv = lib.mkDefault true;
      })
      (lib.mkIf (config.systemConfig.desktop) {
        optimiseFor = "desktop";
        graphicalEnv = lib.mkDefault true;
      })
    ];})

    (config.lib.specialConfig) ## TODO: Not sure if this will work, need another way if it doesn't
  ];
}