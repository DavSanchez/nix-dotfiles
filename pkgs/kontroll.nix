{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kontroll";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "kontroll";
    tag = finalAttrs.version;
    hash = "sha256-rixlq9w1r/TPV9FI076OLIk5Gs5UvfmjCnZ8wLWc3gc=";
  };

  cargoHash = "sha256-04jd5Oqm2Ec7rpj7x3FidRCtGJ10phEbOe0PsvgsS/Y=";

  nativeBuildInputs = [
    protobuf
  ];

  meta = {
    description = "Kontroll demonstates how to control the Keymapp API, making it easy to control your ZSA keyboard from the command line and scripts";
    homepage = "https://github.com/zsa/kontroll";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "kontroll";
  };
})
