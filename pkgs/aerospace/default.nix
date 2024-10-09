{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  xcodegen,
}:
stdenv.mkDerivation rec {
  name = "aerospace";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "nikitabobko";
    repo = "AeroSpace";
    rev = "v${version}-Beta";
    sha256 = "sha256-fMsw4Oos7ddcvr/agAN3KZMJ8o8N9UTIqipR+qF8jAk=";
  };

  # src = /Users/david/Developer/AeroSpace;

  # We remove references to the setup script because we already have the dependencies in PATH
  # Also replace calls to `bundle install` `bundle exec asciidoc` because we use  `asciidoc` directly
  patches = [
    ./remove-setup.patch
    ./remove-ruby.patch
    ./remove-deps.patch
  ];

  buildInputs = [ ];

  nativeBuildInputs = with pkgs; [
    # Darwin specifics
    darwin.sigtool
    swiftlint
    xcbuild
    xcodegen # Upstream first!

    antlr

    git
    xcbeautify

    ## For shell completions
    complgen
    bash
    fish
    zsh

    # For manpages
    asciidoctor
  ];

  buildPhase = ''
    # https://github.com/nikitabobko/AeroSpace/blob/main/dev-docs/development.md

    # Calls to `cargo` and others create config in $HOME
    HOME=$TMPDIR

    ./build-release.sh
  '';

  installPhase = '''';

  meta = {
    description = "AeroSpace is an i3-like tiling window manager for macOS";
    homepage = "https://nikitabobko.github.io/AeroSpace/guide";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
