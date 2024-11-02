{
  lib,
  stdenv,
  clang,
  gcc,
  readline,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "sketchybar-lua";
  version = "0.0.0.0";
  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SbarLua";
    rev = "437bd2031da38ccda75827cb7548e7baa4aa9978";
    hash = "sha256-F0UfNxHM389GhiPQ6/GFbeKQq5EvpiqQdvyf7ygzkPg=";
  };
  nativeBuildInputs = [
    clang
    gcc
  ];
  buildInputs = [ readline ];
  installPhase = ''
    mv bin "$out"
  '';

  meta = {
    description = "A Lua API for SketchyBar";
    homepage = "git@github.com:FelixKratz/SbarLua.git";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "sbar-lua";
    platforms = lib.platforms.darwin;
  };
}
