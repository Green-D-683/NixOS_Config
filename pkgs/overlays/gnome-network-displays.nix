{...}:
self: super: {
  gnome-network-displays = super.gnome-network-displays.overrideAttrs(final: prev: {
    buildInputs = prev.buildInputs ++ (with self.gst_all_1; [
      gstreamer
      gst-plugins-good
      gst-plugins-ugly
      gst-plugins-bad
      gst-libav
      gst-vaapi
    ]) ++ (with self; [
      openh264
      x264
    ]);
  });
}