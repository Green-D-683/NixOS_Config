# {
#   name = "< name of attrset value >";
#   platform = "< platform of system - some kind of linux >";
#   configModule = "< nixosModule to import with system-specific configuration >";
#   extraModules = []; # Any extra modules to import - probably should be imported in the specified nixosModule instead
# }
{self, ...}: {
    name = "UnknownDevice";
    platform = "x86_64-linux";
    # platform = "aarch64-linux";
    extraModules = [
    ];
}
