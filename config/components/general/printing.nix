{config, pkgs, ...}:

{
  config = {
    # Enable CUPS to print documents.
    services= {
      printing.enable = true;
      avahi = {
        enable=true;
        nssmdns=true;
        openFirewall=true;
      };
    };
  }; 
}