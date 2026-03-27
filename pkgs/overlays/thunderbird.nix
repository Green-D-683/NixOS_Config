{...}:
self: super: rec {
    thunderbird-tmp-unwrapped = super.thunderbird-latest-bin-unwrapped.override{
        generated = {
            version = "149.0";
            sources = [
                {
                    url = "https://archive.mozilla.org/pub/thunderbird/releases/149.0/linux-x86_64/uk/thunderbird-149.0.tar.xz";
                    locale = "uk";
                    arch = "linux-x86_64";
                    sha256 = "556ba9757d114596c0ce6b4861a2ac500252b00d14199d4289a3be3b1267b78d";
                }
                {
                    url = "https://archive.mozilla.org/pub/thunderbird/releases/149.0/mac/uk/Thunderbird%20149.0.dmg";
                    locale = "uk";
                    arch = "mac";
                    sha256 = "8615d4723f7c31147291855ffc66109a2e4f74838321ef8400629dfb7e22b99e";
                }
            ];
        };
        systemLocale = "uk";
    };
    thunderbird = self.wrapThunderbird thunderbird-tmp-unwrapped {
        pname = "thunderbird";
    };
}
