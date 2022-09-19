{...}:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
# We use a custom module for VSCode
{
  imports = [./package.nix];

  modules.home.editors.vscode = {
    enable = true;
    mutable = true;
  };
}
