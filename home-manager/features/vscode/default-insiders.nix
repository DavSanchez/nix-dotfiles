{pkgs, ...}:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
# We use a custom module for VSCode
{
  home.packages = [
    ((pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=darwin-universal";
        sha256 = "sha256:17nmla90ykqr2n192v6gka544zw63g66kzpsn38ihgqf2kkhdg8d";
      };
      version = "latest";
    }))
  ];
}
