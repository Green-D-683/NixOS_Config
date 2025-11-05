{withSecrets ? true}:
{lib, ...}:
{
    imports = lib.getDirRec ./. withSecrets;
}
