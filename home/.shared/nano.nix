{config, ...}:
{
    config.home.file.".nanorc"={
        enable = true;
        text = ''
            set tabsize 4
            set tabstospaces

            include /etc/profiles/per-user/${config.home.username}/share/nano/*.nanorc
        '';
    };
}
