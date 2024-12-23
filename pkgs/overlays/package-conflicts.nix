{...}:
self: super: {
  toybox = super.toybox.overrideAttrs (attrs: {
      # Lower priority than gcc.
      meta.priority = super.coreutils.meta.priority + 1;
    });
}