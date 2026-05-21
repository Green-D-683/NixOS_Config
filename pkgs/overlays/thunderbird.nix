{...}:
self: super: rec {
    thunderbird-tmp-unwrapped = super.thunderbird-latest-bin-unwrapped.override{
        systemLocale = "en-GB";
    };
    thunderbird = self.wrapThunderbird thunderbird-tmp-unwrapped {
        pname = "thunderbird";
    };
}
