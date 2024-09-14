{lib, config, ...}:
{
  config = let cfg = config.args.cfg; in {
    userModule = (
      if cfg.isNixOS then (lib.getUser config.home.username cfg) else cfg
    );
  };
}