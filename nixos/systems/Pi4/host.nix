{self, ...}: {
    name = "UnknownPi4";
    platform = "aarch64-linux";
    extraModules = [
        self.inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];
}
