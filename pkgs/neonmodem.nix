{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "neonmodem";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "neonmodem";
    rev = "v${version}";
    hash = "sha256-gc3uPck+2ecqpRtnkvjlTX6H4Dsvn4iynhZEJsNO1bo=";
  };

  vendorHash = "sha256-EGltrOKPHpgRNYspIv7LuGJ6SvCtp7TGap/DBa8yHZg=";

  ldflags = [ "-X github.com/mrusme/neonmodem/config.VERSION=${version}" ];

  meta = with lib; {
    description = "Neon Modem Overdrive";
    homepage = "https://github.com/mrusme/neonmodem.git";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "neonmodem";
  };
}
