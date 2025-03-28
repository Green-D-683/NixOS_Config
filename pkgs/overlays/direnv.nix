{...}:
self: super: {
  direnv = super.direnv.overrideAttrs (old: {
    nativeCheckInputs = [];
    checkPhase = ''
      export HOME=$(mktemp -d)
      make test-go test-bash
    '';
  });
}