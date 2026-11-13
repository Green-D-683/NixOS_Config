{inputs, ...}: self: super: {
    asus-wmi-screenpad-for-kernel = kernel: inputs.screenpad-driver.defaultPackage.${self.stdenv.hostPlatform.system}.override {inherit kernel;};
}
