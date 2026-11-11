{
    config,
    pkgs,
    lib,
    ...
}: {
    config.boot = {
        # Reading Windows/External Drives
        supportedFilesystems = [
            "ntfs"
            "exfat"
            # "apfs" # Currently broken
        ];
    };
}
