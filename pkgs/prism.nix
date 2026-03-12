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

    out_lib="$out/lib/prism"
    mkdir -p "$out_lib"

    # Copy compiled dist output and package.json for each workspace package.
    # After yarn build, each packages/*/dist/ contains the compiled TypeScript.
    for pkg in core http http-server cli; do
      mkdir -p "$out_lib/packages/$pkg"
      cp -r "packages/$pkg/dist" "$out_lib/packages/$pkg/"
      cp "packages/$pkg/package.json" "$out_lib/packages/$pkg/"
      # Copy any package-local node_modules (yarn may leave unhoisted deps here)
      if [[ -d "packages/$pkg/node_modules" ]]; then
        cp -r "packages/$pkg/node_modules" "$out_lib/packages/$pkg/"
      fi
    done

    # Copy hoisted node_modules to the output, skipping:
    #   - Hidden dirs (.yarn-integrity, .cache, .bin — build-only artifacts)
    #   - Workspace package symlinks (recreated below with absolute store paths)
    mkdir -p "$out_lib/node_modules"
    for entry in node_modules/*/; do
      name="$(basename "''${entry%/}")"
      [[ "$name" == .* ]] && continue
      [[ -L "node_modules/$name" ]] && continue
      cp -r "$entry" "$out_lib/node_modules/"
    done

    # Handle @-scoped packages (e.g. @stoplight/json, @types/*, etc.)
    for scope_dir in node_modules/@*/; do
      [[ -d "$scope_dir" ]] || continue
      scope="$(basename "''${scope_dir%/}")"
      mkdir -p "$out_lib/node_modules/$scope"
      for entry in "''${scope_dir}"*/; do
        name="$(basename "''${entry%/}")"
        # Skip workspace symlinks (e.g. @stoplight/prism-core -> ../../packages/core)
        [[ -L "''${scope_dir}''${name}" ]] && continue
        cp -r "$entry" "$out_lib/node_modules/$scope/"
      done
    done

    # Recreate workspace package symlinks with absolute Nix store paths.
    # In the source tree these were relative symlinks (../../packages/*), which
    # would break after copying. Node.js resolves modules by traversing up from
    # the entry point, so $out_lib/node_modules is found from packages/cli/dist/.
    mkdir -p "$out_lib/node_modules/@stoplight"
    for pkg in core http http-server cli; do
      rm -rf "$out_lib/node_modules/@stoplight/prism-$pkg"
      ln -sf "$out_lib/packages/$pkg" "$out_lib/node_modules/@stoplight/prism-$pkg"
    done

    # Wrap the CLI entry point with the correct Node.js interpreter
    mkdir -p "$out/bin"
    makeWrapper "${nodejs}/bin/node" "$out/bin/prism" \
      --add-flags "$out_lib/packages/cli/dist/index.js"

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
