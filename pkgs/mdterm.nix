{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdterm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "mdterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MPSCtJ9QCLkZ7GyLi3kRStgX1DTweynxI7MbqXg2Kq0=";
  };

  cargoHash = "sha256-v6Kb7UKn0ooQOvdgvVJhiicTocYXVa6aEsHCUPigZXg=";

  meta = {
    description = "A terminal-based Markdown browser";
    homepage = "https://github.com/bahdotsh/mdterm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DavSanchez ];
    mainProgram = "mdterm";
  };
})
