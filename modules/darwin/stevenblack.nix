{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.stevenblack;

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
  options.networking = {
    hostFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression "[ pkgs.stevenblack-blocklist.ads ]";
      description = ''
        List of files that should be merged into /etc/hosts.
        The files are concatenated in order. Note that the resulting
        file fully replaces the default macOS /etc/hosts, so you may
        want to include localhost entries in your first file.
      '';
    };

    stevenBlack = {
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
  };

  config = lib.mkIf (config.networking.hostFiles != [ ] || cfg.enable) {
    networking.hostFiles = lib.mkIf cfg.enable (
      map (x: filterHostsFile "${lib.getOutput x cfg.package}/hosts") ([ "ads" ] ++ cfg.block)
    );

    environment.etc."hosts".source = lib.mkIf (config.networking.hostFiles != [ ]) (
      pkgs.runCommand "hosts" { preferLocalBuild = true; } ''
        cat ${lib.escapeShellArgs config.networking.hostFiles} > $out
      ''
    );
  };
}
