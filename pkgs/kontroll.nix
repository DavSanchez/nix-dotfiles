{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
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

  cargoHash = "sha256-04jd5Oqm2Ec7rpj7x3FidRCtGJ10phEbOe0PsvgsS/Y=";

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

  meta = {
    description = "Kontroll demonstates how to control the Keymapp API, making it easy to control your ZSA keyboard from the command line and scripts";
    homepage = "https://github.com/zsa/kontroll";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.davsanchez ];
    mainProgram = "kontroll";
  };
}
