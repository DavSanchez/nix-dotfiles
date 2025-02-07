{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "kontroll";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "kontroll";
    rev = version;
    hash = "sha256-SSKAueJbDhziEwM6VcMKgvgdNdZWCXVJUj0P4EQtiKs=";
  };

  cargoHash = "sha256-D0lpbJdA8IcDebU7KWG/Kw/rjuJZ6ZVxxhlDHVS1Hfg=";

  nativeBuildInputs = [
    protobuf
  ];

  # Integration tests ($src/tests) are not complete (trait impls are `todo!()`)
  # so we just enable the rest
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--examples"
  ];

  checkInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Foundation
      AppKit
      Vision
      AVFoundation
      MetalKit
    ]
  );

  meta = {
    description = "Kontroll demonstates how to control the Keymapp API, making it easy to control your ZSA keyboard from the command line and scripts";
    homepage = "https://github.com/zsa/kontroll";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.davsanchez ];
    mainProgram = "kontroll";
  };
}
