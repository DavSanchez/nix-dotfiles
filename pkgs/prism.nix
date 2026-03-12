{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prism-cli";
  version = "5.14.3";

  src = fetchFromGitHub {
    owner = "stoplightio";
    repo = "prism";
    rev = "adab4dd446d45d7e8b1588fe76a40dd0efaf8d33";
    hash = "sha256-bVUwElcoKlDYxfytOGa8O2v2z2iczEqfL58PGNUOOSM=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-tFE9KLKOojfTqM1/5SNbA6fc36FGBMPKkPTJ0z1FIi0=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    makeWrapper
  ];

  # Root package.json build script: npm run clean && ttsc --build --verbose ./packages/tsconfig.build.json
  # yarnBuildHook runs "yarn build" by default which matches. ttsc is available via node_modules/.bin
  # since yarnConfigHook installs all deps (including devDeps) before build.

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/prism" "$out/bin"
    # -L resolves workspace symlinks (e.g. @stoplight/prism-cli -> ../../packages/cli)
    # into real directories so the store path is self-contained.
    cp -rL node_modules "$out/lib/prism/node_modules"
    makeWrapper "${nodejs}/bin/node" "$out/bin/prism" \
      --add-flags "$out/lib/prism/node_modules/@stoplight/prism-cli/dist/index.js"
    runHook postInstall
  '';

  meta = {
    description = "Turn any OpenAPI2/3 and Postman Collection file into an API server with mocking, transformations and validations";
    homepage = "https://github.com/stoplightio/prism";
    changelog = "https://github.com/stoplightio/prism/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "prism";
    platforms = lib.platforms.unix;
  };
})
