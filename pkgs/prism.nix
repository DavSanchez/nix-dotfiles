{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "prism-cli";
  version = "5.14.2";

  # Use the published npm package instead of building from source
  src = fetchurl {
    url = "https://registry.npmjs.org/@stoplight/prism-cli/-/prism-cli-${version}.tgz";
    hash = "sha256-YaO0X7sDJbhfvpS6+DZYjeZ2wNuRw7HxkXOAcML3QQ8=";
  };

  npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  dontNpmBuild = true;

  meta = {
    description = "Turn any OpenAPI2/3 and Postman Collection file into an API server with mocking, transformations and validations";
    homepage = "https://github.com/stoplightio/prism";
    changelog = "https://github.com/stoplightio/prism/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "prism";
    platforms = lib.platforms.unix;
  };
}
