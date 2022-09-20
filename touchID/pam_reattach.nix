{
  fetchgit,
  stdenv,
  lib,
  darwin,
  cmake,
  ...
}: let
  sdk =
    if stdenv.isAarch64
    then darwin.apple_sdk.MacOSX-SDK
    else darwin.apple_sdk.sdk;
in
  stdenv.mkDerivation rec {
    name = "pam-reattach";
    version = "1.2";

    src = fetchgit {
      url = "https://github.com/fabianishere/pam_reattach";
      rev = "b144392c7c98631dd074fddc5f9344286587004b";
      sha256 = "5y/Wf8Yu4Y/AkiwRk1bxjqwrhHxUHQ7Kyo+3r3Gf58w=";
    };

    buildInputs = [cmake sdk];

    configurePhase = ''
      CMAKE_LIBRARY_PATH="${sdk}/usr/lib" cmake \
        -DCMAKE_INSTALL_PREFIX=$out \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_PAM=true \
        -DENABLE_CLI=true \
        .
    '';

    meta = with lib; {
      description = "Reattach to the user's GUI session on macOS during authentication (for Touch ID support in tmux)";
      homepage = "https://github.com/fabianishere/pam_reattach";
      licenses = licenses.mit;
      maintainers = with maintainers; [congee];
      platforms = ["x86_64-darwin" "aarch64-darwin"];
    };
  }
