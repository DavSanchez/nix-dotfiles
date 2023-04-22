{pkgs, ...}: {
  home.packages = with pkgs; [
    cotp
    # oath-toolkit
  ];

  programs = {
    gpg.enable = true;
    password-store.enable = true;
  };
}
