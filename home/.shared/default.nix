{lib, config, ...}:{
  
  imports = lib.getDir (./.);

  ## Use this to pass extra arguments to home-manager
  options = let mkOption = lib.mkOption; types = lib.types; in {
      args = mkOption {
        type = types.attrs;
        default = {};
      };
      userModule = mkOption {
        type = types.submodule lib.userModule;
        description = "User-Specific Configuration passed from NixOS";
      };
      isNixOS = lib.mkOption {
        type = types.bool;
        visible = false;
        default = false;
      };
  };

  config = {
      programs.plasma={
        enable = true;
        immutableByDefault=true;
      };
      isNixOS = (if config.args ? isNixOS then config.args.isNixOS else false);
  };
}