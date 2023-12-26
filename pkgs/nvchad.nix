{
  stdenv,
  pkgs,
  fetchFromGithub,
}:
stdenv.mkDerivation {
  pname = "nvchad";
  version = "2.0";
  dontBuild = true;

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "9bb7dcbaf4ed3ac38b6de4d452d2942f89e357c0";
    hash = "sha256-Fo5Qk7ezpm1mlBCEfL0It0MVMoW3CDV9asROJUs3V0w=";
  };

  installPhase = ''
    # Fetch the whole repo and put it in $out
    mkdir $out
    cp -aR $src/* $out/
  '';
}
