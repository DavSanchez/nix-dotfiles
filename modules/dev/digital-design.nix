{pkgs, ...}: {
  home.packages = with pkgs; [
    yosys
    verilator
    # verible
    # veridian ??
    # clash # Check possibilities
  ];
}
