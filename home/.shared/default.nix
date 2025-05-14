{lib, config, pkgs, ...}:{
  
  imports = lib.getDir (./.);

  ## Use this to pass extra arguments to home-manager
  options = let mkOption = lib.mkOption; types = lib.types; in {
      args = mkOption {
        type = types.submodule {
          options = {
            cfg = mkOption {
              type = types.attrs; #with types; either (lib.userModule) (attrsOf (oneOf [lib.userModule bool (listOf str)] ));
            };
            system = mkOption {
              type = types.str;
              default = "x86_64-linux";
            };
            flake = mkOption {
              type = types.attrs;
            };
            isNixOS = lib.mkOption {
              type = types.bool;
              default = false;
            };
            isNixOnDroid = lib.mkOption {
              type = types.bool;
              default = false;
            };
          };
        };
        default = {};
      };
      userModule = mkOption {
        type = lib.userModule;
        description = "User-Specific Configuration passed from NixOS";
      };
      isNixOS = lib.mkOption {
        type = types.bool;
        visible = false;
        default = false;
      };
      isNixOnDroid = lib.mkOption {
        type = types.bool;
        visible = false;
        default = false;
      };
  };

  config = {
    programs = {
      plasma={
        enable = true;
        immutableByDefault=true;
      };
      home-manager = {
        enable = true;
      };
    };
    
    isNixOS = (if config.args ? isNixOS then config.args.isNixOS else false);

    isNixOnDroid = (if config.args ? isNixOnDroid then config.args.isNixOnDroid else false);
    
    userModule = (let cfg = config.args.cfg; in (if config.isNixOS then (lib.getUser config.home.username cfg) else cfg));

    home = {
        packages = (builtins.concatLists (builtins.map (x: import ../../pkgs/programs/${x}.nix {inherit pkgs;}) config.userModule.install-lists)) ++ (with pkgs; [ home-manager nil ]) ++ (lib.optionals (pkgs.system == "x86_64-linux") [pkgs.steam-run]);
        sessionVariables = {
            "EDITOR" = lib.mkDefault "${pkgs.nano}/bin/nano";
        };
    };

    systemd.user.startServices = "sd-switch";

    programs.bash.bashrcExtra = lib.mkMerge [
        (lib.mkIf (config.isNixOnDroid) ''
          export DNSHACK_RESOLVER_CMD="${pkgs.dnshack}/bin/dnshackresolver
          export LD_PRELOAD="${pkgs.dnshack}/lib/libdnshackbridge.so
        '')
    ];
  };
}
