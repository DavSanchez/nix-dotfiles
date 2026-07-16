{
  config,
  lib,
  pkgs,
  ...
}:
let
  localhostHosts = pkgs.writeText "localhost-hosts" ''
    127.0.0.1 localhost
    ::1 localhost
  '';

  stringHosts =
    let
      oneToString = set: ip: ip + " " + lib.concatStringsSep " " set.${ip} + "\n";
      allToString = set: lib.concatMapStrings (oneToString set) (lib.attrNames set);
    in
    pkgs.writeText "string-hosts" (
      allToString (lib.filterAttrs (_: v: v != [ ]) config.networking.hosts)
    );

  extraHosts = pkgs.writeText "extra-hosts" config.networking.extraHosts;

  generatedHosts = pkgs.concatText "hosts" (
    [
      localhostHosts
      stringHosts
      extraHosts
    ]
    ++ config.networking.hostFiles
  );
in
{
  options.networking = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      example = lib.literalExpression ''
        {
          "127.0.0.1" = [ "foo.bar.baz" ];
          "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
        }
      '';
      description = ''
        Locally defined maps of hostnames to IP addresses.
      '';
    };

    extraHosts = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional verbatim entries to be appended to {file}`/etc/hosts`.
        For adding hosts from derivation results, use {option}`networking.hostFiles` instead.
      '';
    };

    hostFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression "[ pkgs.stevenblack-blocklist.ads ]";
      description = ''
        List of files that should be concatenated into {file}`/etc/hosts`.
      '';
    };
  };

  config = {
    system.activationScripts.postActivation.text =
      let
        hasHostsContent =
          config.networking.hosts != { }
          || config.networking.extraHosts != ""
          || config.networking.hostFiles != [ ];
      in
      ''
        printf >&2 'setting up /etc/hosts...\n'

        hostsOriginal=""
        if [[ -f /etc/hosts ]]; then
          hostsOriginal="$(sed '/^# BEGIN Nix-managed$/,/^# END Nix-managed$/d' /etc/hosts)"
        fi

        ${
          if hasHostsContent then
            ''
              {
                if [[ -n "$hostsOriginal" ]]; then
                  printf '%s\n' "$hostsOriginal"
                fi
                printf '# BEGIN Nix-managed\n'
                cat ${generatedHosts}
                printf '# END Nix-managed\n'
              } > /etc/hosts
            ''
          else
            ''
              if [[ -n "$hostsOriginal" ]]; then
                printf '%s\n' "$hostsOriginal" > /etc/hosts
              fi
            ''
        }
      '';
  };
}
