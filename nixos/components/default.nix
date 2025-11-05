{lib, ...}:

{
  imports = lib.getDirRec ./. true;
}
