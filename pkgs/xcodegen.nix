{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "XcodeGen";

  src = fetchFromGitHub {
    owner = "yonaskolb";
    repo = "XcodeGen";
    rev = "2.42.0";
    sha256 = "sha256-wcjmADG+XnS2kR8BHe6ijApomucS9Tx7ZRjWZmTCUiI=";
  };

  nativeBuildInputs = [ pkgs.swift ];

  buildPhase = ''
    make build

    ls -lah
  '';

  meta = {
    description = "A Swift command line tool for generating your Xcode project";
    homepage = "https://github.com/yonaskolb/XcodeGen";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
