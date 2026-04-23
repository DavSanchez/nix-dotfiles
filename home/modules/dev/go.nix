{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.go = {
    enable = true;
    env.GOPATH = toString (lib.path.append (/. + config.home.homeDirectory) ".go");
  };

  home.packages = with pkgs; [
    # gopls # Langserver
    # langserver but removing modernize. REVIEW: when NixOS/nixpkgs#509480 gets addressed
    (pkgs.symlinkJoin {
      name = "gopls-sans-modernize";
      paths = [ gopls ];
      postBuild = ''
        rm -f "$out/bin/modernize"
      '';
    })
    capslock
    go-task
    gotools
    go-tools
    gofumpt
    gomodifytags
    gotests
    gore
    godef
    delve
    gdlv
    impl
    golangci-lint
  ];
}
