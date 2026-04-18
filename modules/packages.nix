_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = import ../pkgs pkgs;
    };
}
