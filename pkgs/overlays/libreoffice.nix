{...}:
self: super: {
    libreoffice = (self.libreoffice-qt.override {
        unwrapped = self.libreoffice-qt-unwrapped.override {
            # This is where the actual compiler flags are defined
            langs = [ "en-GB" ];
        };
    });
    # libreoffice = self.libreoffice-bin; # Darwin only
}
