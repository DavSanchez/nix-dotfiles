{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  IOKit,
  CoreFoundation,
  Security,
}:
buildGoModule rec {
  pname = "infrastructure-agent";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = version;
    hash = "sha256-0eq4igAqtzkb2bsNWPZCOeKd1X3mL3z5BiIs01BJPu8=";
  };

  vendorHash = "sha256-YOdNoUkPAGknv82RQRk36Be8uGfkrhNETJv54jnHAB8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    IOKit
    CoreFoundation
    Security
  ];

  ldflags = ["-s" "-w"];

  CGO_ENABLED =
    if stdenv.isDarwin
    then "1"
    else "0";

  subPackages = [
    "cmd/newrelic-infra"
    "cmd/newrelic-infra-ctl"
    "cmd/newrelic-infra-service"
  ];

  meta = with lib; {
    description = "New Relic Infrastructure Agent";
    homepage = "https://github.com/newrelic/infrastructure-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [DavSanchez];
  };
}
