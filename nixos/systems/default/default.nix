{config, lib, ...}:

{
  imports = [
    ../../components
    ../../../home
  ];

  options = let 
  mkOption = lib.mkOption;
  mkEnableOption = lib.mkEnableOption;
  types = lib.types; 
  in {
    userConfig = {
      users = mkOption{
        default = ["daniel"];
        type = with types; listOf (enum []);
        description = "The users to include for the device";
      };

      hasScreenpad = mkOption{
        visible = false;
        type = types.bool;
        default = false;
      };

      isNixOS = mkOption{
        visible = false;
        type = types.bool;
        default = true;
      };

      userModules = mkOption {
        type = types.attrsOf lib.userModule;
        default = {
          "default"={};
        };
      };
    };

    

    systemConfig={

      ## Power Optimisations - This also can enable graphics by default for Desktops and Laptops
      laptop = mkEnableOption "Laptop Optimisations";
      desktop = mkEnableOption "Desktop Optimisations";
      optimiseFor = mkOption{ # Handles Mutual Exclusivity - not for direct use
        default = "";
        type = types.enum ["" "laptop" "desktop" "server"];
        visible = false;
      };

      ## Graphical User Environment
      graphicalEnv = mkEnableOption "Graphical User Interface";
      gpu = mkOption{
        default = "";
        type = types.enum ["" "intel" "nvidia" "amd"];
      };

      ## Common Hardware
      extraHardware = mkOption{
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
      hostname = mkOption {
        default = "UnknownDevice";
        type = types.str;
        description = "Hostname for Network connections";
      };

      # ## Any Extra Config not Covered by Generic Modules
      # specialConfig = mkOption {
      #   type = types.anything;
      # };
    };
  };

  config = lib.mkMerge [
    ({systemConfig = lib.mkMerge [
      (lib.mkIf (config.systemConfig.laptop) {
        optimiseFor = "laptop";
        #graphicalEnv = lib.mkDefault true;
      })
      (lib.mkIf (config.systemConfig.desktop) {
        optimiseFor = "desktop";
        #graphicalEnv = lib.mkDefault true;
      })
    ];})

    ({userConfig = lib.mkMerge [
      (lib.mkIf (builtins.elem "screenpad" config.systemConfig.extraHardware){
        hasScreenpad = true;
      })
    ];})
    
    #(config.systemConfig.specialConfig) ## TODO: Not sure if this will work, need another way if it doesn't
  ];
}