{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yosys
    verilator
    # clash # Check possibilities
  ];
}
