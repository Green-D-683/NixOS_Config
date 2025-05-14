{...}:
self: super: {
  dnshack = self.callPackage (builtins.fetchTarball "https://github.com/ettom/dnshack/tarball/master") {};
}
