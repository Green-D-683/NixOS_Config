{config, pkgs, ...}:

{
  config = {
    # Enable CUPS to print documents.
    services= {
      printing = {
        enable = true;
        drivers = [
          pkgs.cups-brother-hll3230cdw
        ];
      };
      avahi = {
        enable=true;
        nssmdns4=true;
        openFirewall=true;
      };
    };
  }; 
}