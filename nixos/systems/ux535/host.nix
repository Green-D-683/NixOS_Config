{self, ...}: {
    name = "UnknownDevice_ux535";
    platform = "x86_64-linux";
    extraModules = [
        self.inputs.nixos-hardware.nixosModules.asus-zenbook-ux535
    ];
}
