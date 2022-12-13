{ lib
, stdenv
, fetchzip
, zlib
, autoPatchelfHook
,
}:
stdenv.mkDerivation rec {
  name = "kcctl";
  version = "1.0.0.Beta1";
  
  baseURL = "https://github.com/kcctl/kcctl/releases/download/v${version}/${name}-${version}";

  meta = with lib; {
    description = "A modern and intuitive command line client for Kafka Connect";
    homepage = "https://github.com/kcctl/kcctl";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  src =
    if stdenv.isLinux
    then
      fetchzip
        {
          url = "${baseURL}-linux-x86_64.zip";
          sha256 = lib.fakeSha256;
        }
    else if stdenv.isDarwin
    then
      fetchzip
        {
          url = "${baseURL}-osx-x86_64.zip";
          sha256 = lib.fakeSha256;
        }
    else throw "Unsupported system: ${stdenv.system}";

  buildInputs = [
    zlib
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -m755 -D source/bin/kcctl $out/bin/kcctl

    runHook postInstall
  '';
}
