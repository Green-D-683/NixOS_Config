{lib, cfg, config, ...}:
let 
mkOption = lib.mkOption;
types = lib.types;
in
{
  options={
    userModule = mkOption {
      type = types.submodule lib.userModule;
      description = "User-Specific Configuration passed from NixOS";
    };
    isNixOS = lib.mkOption {
      type = types.bool;
      visible = false;
      defaut = false;
    };
  };

  config = {
    isNixOS = lib.attrsets.attrByPath ["isNixOS"] false cfg;
    userModule = (
      if config.isNixOS then (lib.getUser cfg) else cfg
    );
  };
}