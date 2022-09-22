{pkgs, ...}: {
  home.packages = with pkgs; [
    ## C
    gcc
    llvm
    cling
    cmake
    # build2
    # conan
    # platformio
  ];
}
