{ lib, stdenv, pkgs, customConf ? null }:
stdenv.mkDerivation {
  pname = "nvchad";
  version = "v2.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "c77c086";
    sha256 = "sha256-3X10A9/poqfD43XlpwPA0nrf0WYZbsm0PymT5x1L7i0=";
  };

  installPhase = ''
    cp -r . $out
  '';

  patchPhase = lib.optionalString (builtins.isPath customConf) ''
    mkdir -p "$out/lua/custom"
    cp -r ${customConf}/* $out/lua/custom/
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
    maintainers = with maintainers; [ DavSanchez rayandrew ];
    license = licenses.gpl3;
  };
}