{ ... }:
{
  home.packages = with pkgs; [
    ## C
    gcc
    llvm
    cling
    cmake
    # conan
  ];
}
