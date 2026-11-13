{
    lib,
    self,
    ...
}: let
    registry = {
        getRegistry =
            builtins.mapAttrs (name: value: {
                from = {
                    id = name;
                    type = "indirect";
                };
                flake = value;
            })
            self.inputs;
    };
in {
    inherit registry;
}
