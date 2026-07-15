{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.stevenBlack;

  filterHostsFile =
    hostsFile:
    if cfg.whitelist == [ ] then
      hostsFile
    else
      let
        pattern = lib.escape [ "." "|" ] (lib.concatStringsSep "|" cfg.whitelist);
      in
      pkgs.runCommand "filtered-hosts" { preferLocalBuild = true; } ''
        sed '/${pattern}/d' ${hostsFile} > $out
      '';
in
{
  options.networking.stevenBlack = {
    enable = lib.mkEnableOption "the stevenblack hosts file blocklist";

    package = lib.mkPackageOption pkgs "stevenblack-blocklist" { };

    block = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "fakenews"
          "gambling"
          "porn"
          "social"
        ]
      );
      default = [ ];
      description = "Additional blocklist extensions.";
    };

    whitelist = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "^[a-zA-Z0-9_-]+([.][a-zA-Z0-9_-]+)+$");
      default = [ ];
      description = "Domains to exclude from blocking.";
      example = [ "s.click.aliexpress.com" ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostFiles = map (x: filterHostsFile "${lib.getOutput x cfg.package}/hosts") (
      [ "ads" ] ++ cfg.block
    );
  };
}
