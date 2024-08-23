{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  name = "aerospace";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "nikitabobko";
    repo = "AeroSpace";
    rev = "v${version}-Beta";
    hash = lib.fakeSha256;
  };

  buildInputs = [ ];

  nativeBuildInputs = [ ];

  buildPhase = ''
  # https://github.com/nikitabobko/AeroSpace/blob/main/dev-docs/development.md
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
