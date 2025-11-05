{pkgs, ...}:
{
    programs = {
        ssh = {
            enable = true;
            package = pkgs.opensshWithKerberos;
            enableDefaultConfig = false;
            matchBlocks."*" = {
                addKeysToAgent = "yes";
            };
        };
    };
    services = {
        ssh-agent = {
            enable = true;
            enableBashIntegration = true;
            package = pkgs.opensshWithKerberos;
        };
    };
}
