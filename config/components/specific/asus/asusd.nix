{pkgs, config, ...}:

{
  config = {
    services.asusd= {
      enable = true; 
      fanCurvesConfig = "30 0,40 10,50 20,60 30,70 40,80 50,90 60,100 70";
    };

    environment.systemPackages = with pkgs; [
      asusctl
    ];

  };
}