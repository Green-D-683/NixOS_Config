{config, pkgs, system, lib, ...}:

{
  config = {
    # Enable CUPS to print documents.
    services= {
      printing = {
        enable = true;
        drivers = lib.optionals (system == "x86_64-linux") [
          pkgs.cups-brother-hll3230cdw
        ];
      };
    };
  }; 
}