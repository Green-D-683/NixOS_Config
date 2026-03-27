{...}:
self: super: rec {
    thunderbird-tmp-unwrapped = super.thunderbird-latest-bin-unwrapped.override{
        generated = {
            version = "149.0";
            sources = [
                {
                    url = "https://archive.mozilla.org/pub/thunderbird/releases/149.0/linux-x86_64/en-GB/thunderbird-149.0.tar.xz";
                    locale = "en-GB";
                    arch = "linux-x86_64";
                    sha256 = "a0f383c0f105c749cb774ec47d18efb9461351e53280658d3f9d0e80371bc3d7";
                }
                {
                    url = "https://archive.mozilla.org/pub/thunderbird/releases/149.0/mac/en-GB/Thunderbird%20149.0.dmg";
                    locale = "en-GB";
                    arch = "mac";
                    sha256 = "2294da6b9756be51d337ed982ca4ce8b3f3567dbc695489a2cb98f132f2137d5";
                }
            ];
        };
        systemLocale = "en-GB";
    };
    thunderbird = self.wrapThunderbird thunderbird-tmp-unwrapped {
        pname = "thunderbird";
    };
}
