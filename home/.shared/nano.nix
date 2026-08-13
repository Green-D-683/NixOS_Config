{config, ...}:
{
    config.home.file.".nanorc"={
        enable = true;
        text = ''
            set tabsize 4
            set tabstospaces

            include ${config.home.profileDirectory}/share/nano/*.nanorc
        '';
    };
}
