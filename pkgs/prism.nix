{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  makeWrapper,
  jq,
}:

let
  src = fetchFromGitHub {
    owner = "stoplightio";
    repo = "prism";
    tag = "v5.16.0";
    hash = "sha256-n8Gvc5N+jiKllftMgIm+Ukqt1xJecYCMMksENJEpbts=";
  };

  patchedSrc = stdenv.mkDerivation {
    name = "prism-cli-5.16.0-src";
    inherit src;
    nativeBuildInputs = [ jq ];
    buildPhase = "true";
    installPhase = ''
      cp -rL $src/. $out
      chmod -R +w $out
      cd $out
      jq '.packages["node_modules/follow-redirects"] += {"resolved": "https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.16.0.tgz", "integrity": "sha512-y5rN/uOsadFT/JfYwhxRS5R7Qce+g3zG97+JrtFZlC9klX/W5hD7iiLzScI4nZqUS7DNUdhPgw4xI8W2LuXlUw=="}' package-lock.json > package-lock.json.tmp && mv package-lock.json.tmp package-lock.json
    '';
  };

  npmDeps = fetchNpmDeps {
    src = patchedSrc;
    hash = "sha256-4TyJYbVErGOXOfSUt/InEE7pmb1e4yKv5j+Hx3xfJr4=";
  };
in

buildNpmPackage {
  pname = "prism-cli";
  version = "5.16.0";

  inherit src patchedSrc npmDeps;

  nativeBuildInputs = [
    makeWrapper
    jq
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/prism" "$out/bin"
    cp -rL node_modules "$out/lib/prism/node_modules"
    makeWrapper "${nodejs}/bin/node" "$out/bin/prism" \
      --add-flags "$out/lib/prism/node_modules/@stoplight/prism-cli/dist/index.js"
    runHook postInstall
  '';

  postPatch = ''
    jq '.packages["node_modules/follow-redirects"] += {"resolved": "https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.16.0.tgz", "integrity": "sha512-y5rN/uOsadFT/JfYwhxRS5R7Qce+g3zG97+JrtFZlC9klX/W5hD7iiLzScI4nZqUS7DNUdhPgw4xI8W2LuXlUw=="}' package-lock.json > package-lock.json.tmp && mv package-lock.json.tmp package-lock.json
  '';

  meta = {
    description = "Turn any OpenAPI2/3 and Postman Collection file into an API server with mocking, transformations and validations";
    homepage = "https://github.com/stoplightio/prism";
    changelog = "https://github.com/stoplightio/prism/releases/tag/v5.16.0";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "prism";
    platforms = lib.platforms.unix;
  };
}
