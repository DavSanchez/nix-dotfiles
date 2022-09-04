{ config, lib, pkgs, ... }:
# VSCode expects writable settings.json
# https://github.com/nix-community/home-manager/issues/1800
with lib;
let
  cfg = config.modules.home.editors.vscode;
  vscodePname = config.programs.vscode.package.pname;

  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  sysDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      "${config.xdg.configHome}";

  userFilePath = "${sysDir}/${configDir}/User/settings.json";
in
{
  options.modules.home.editors.vscode = {
    enable = mkEnableOption "VS Code";
    mutable = mkEnableOption "Mutable configuration";
  };

  config = mkIf cfg.enable {
    home = {
      activation = mkIf cfg.mutable {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          rm -rf "${userFilePath}"
        '';

        overwriteVSCodeSymlink =
          let
            userSettings = config.programs.vscode.userSettings;
            jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
          in
          lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            rm -rf "${userFilePath}"
            cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${userFilePath}"
          '';
      };
    };

    programs.vscode = {
      enable = true;
      extensions = import ./extensions.nix { inherit pkgs; };
      package = pkgs.vscodium;
      userSettings = lib.importJSON ./settings.json;
    };
  };
}

