{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      rustup
      rust-analyzer # Not yet distributed via rustup
    ];
  };
}
