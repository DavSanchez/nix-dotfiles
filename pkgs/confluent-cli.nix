{ pkgs, lib }:
# See https://github.com/krisajenkins/confluent-niv
pkgs.stdenv.mkDerivation rec {
  name = "confluent-cli";
  version = "2.37.0";
  src = pkgs.fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${version}/confluent_v${version}_darwin_arm64.tar.gz";
    sha256 = "sha256-8Jo7R64shhaVYTPKYUf70Cs06LIRh5WiaLFyCv4E1ho=";
  };

  dontFixup = true;

  installPhase = ''
    mkdir -p $out/bin/
    install -m755 -D confluent $out/bin/
  '';
}