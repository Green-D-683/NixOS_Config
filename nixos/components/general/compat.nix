{
    pkgs,
    lib,
    ...
}: {
    config = {
        programs.nix-ld.enable = lib.mkDefault true;

        # Sets up all the libraries to load
        programs.nix-ld.libraries = pkgs.steam-run.args.multiPkgs pkgs;
    };
}
