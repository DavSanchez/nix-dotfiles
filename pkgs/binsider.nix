{
  lib,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "binsider";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "binsider";
    rev = "v${version}";
    hash = "sha256-VnWLslelEAXuSy7XnxrdgSkXqTrd+Ni7lQFsB2P+ILs=";
  };

  cargoHash = "sha256-eBZ7zUOucarzdxTjHecUxGqUsKTQPaaotOfs/v0MxHk=";

  buildNoDefaultFeatures = stdenv.isDarwin;

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      AppKit
      CoreServices
    ]
  );

  doCheck = !stdenv.isDarwin;
  # Tests need the executable in target/debug/
  preCheck = ''
    cargo build
  '';

  meta = with lib; {
    description = "Analyzer of executables using a terminal user interface";
    homepage = "https://github.com/orhun/binsider";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ samueltardieu ];
    mainProgram = "binsider";
  };
}
