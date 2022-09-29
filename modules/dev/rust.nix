{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      rustup
      rust-analyzer
    ];
  };
}
