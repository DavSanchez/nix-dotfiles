{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    rosetta.gdb

    llvm
    lldb

    cling
    ccls
    
    # gnumake already defined in module top level
    cmake
    # platformio
  ];
}
