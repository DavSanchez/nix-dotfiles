{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gandi-livedns;
  tsEnabled = config.services.tailscale.enable;
in
{
  options.services.gandi-livedns = {
    enable = lib.mkEnableOption "Gandi LiveDNS dynamic DNS updater for private and Tailscale IPs";

    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a file containing GANDI_TOKEN=your_pat.
        The file is sourced at runtime so the token is never baked into the Nix store.
      '';
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Base domain managed by Gandi (e.g. example.com).";
      example = "example.com";
    };

    subdomain = lib.mkOption {
      type = with lib.types; either str (listOf str);
      apply = x: if lib.isList x then x else [ x ];
      description = ''
        Subdomain(s) to update (e.g. [ "*.mora" "mora" ] or "mora").
        Can be a single string or a list of strings.
        The record will point to this host's private local IPs and Tailscale IP(s).
      '';
      example = [ "*.mora" "mora" ];
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "5min";
      description = "Systemd timer OnUnitActiveSec interval.";
      example = "10min";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gandi-livedns = {
      description = "Gandi LiveDNS Private IP Updater";
      after = [ "network-online.target" ] ++ lib.optional tsEnabled "tailscaled.service";
      wants = [ "network-online.target" ] ++ lib.optional tsEnabled "tailscaled.service";
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        LoadCredential = [ "gandi_token:${cfg.tokenFile}" ];
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "gandi-livedns";
            runtimeInputs = [
              pkgs.curl
              pkgs.jq
              pkgs.iproute2
            ];
            text = ''
              GANDI_TOKEN=$(sed -n 's/^GANDI_TOKEN=//p' "''${CREDENTIALS_DIRECTORY}/gandi_token")
              if [[ -z "''${GANDI_TOKEN:-}" ]]; then
                echo "ERROR: GANDI_TOKEN not found in credential file" >&2
                exit 1
              fi

              API_BASE="https://api.gandi.net/v5/livedns/domains/${cfg.domain}/records"

              all_addrs=$(ip -json addr show)

              mapfile -t ipv4_addrs < <(echo "$all_addrs" | jq -r '
                [
                  (.[]
                    | select(.ifname != "lo" and (.ifname | test("^(docker|veth|br-|tailscale|utun)") | not))
                    | .addr_info[]
                    | select(.family == "inet" and .scope == "global")
                    | .local
                    | split(".")
                    | select(.[0] == "192" and .[1] == "168")
                    | join("."))
                  ${lib.optionalString tsEnabled ''
                    ,
                    (.[]
                      | select(.ifname == "tailscale0")
                      | .addr_info[]
                      | select(.family == "inet" and .scope == "global")
                      | .local
                      | split(".")
                      | select(.[0] == "100" and (.[1] | tonumber) >= 64 and (.[1] | tonumber) <= 127)
                      | join("."))
                  ''}
                ] | unique | .[]
              ')

              mapfile -t ipv6_addrs < <(echo "$all_addrs" | jq -r '
                [
                  (.[]
                    | select(.ifname != "lo" and (.ifname | test("^(docker|veth|br-|tailscale|utun)") | not))
                    | .addr_info[]
                    | select(.family == "inet6" and .scope == "global")
                    | .local
                    | select((startswith("fc") or startswith("fd")) and (startswith("fe80:") | not)))
                  ${lib.optionalString tsEnabled ''
                    ,
                    (.[]
                      | select(.ifname == "tailscale0")
                      | .addr_info[]
                      | select(.family == "inet6" and .scope == "global")
                      | .local
                      | select(startswith("fd7a:115c:a1e0")))
                  ''}
                ] | unique | .[]
              ')

              update_record() {
                local subdomain="$1"
                local record_type="$2"
                shift 2
                local ips=("$@")
                local url="$API_BASE/$subdomain/$record_type"

                if [[ ''${#ips[@]} -eq 0 ]]; then
                  echo "WARN: No $record_type IPs found, skipping $subdomain" >&2
                  return 0
                fi

                local values_json new_values payload
                values_json=$(printf '%s\n' "''${ips[@]}" | jq -Rs 'split("\n") | map(select(length > 0))')
                new_values=$(echo "$values_json" | jq -c 'sort')
                payload=$(echo "$values_json" | jq '{rrset_ttl: 10800, rrset_values: .}')

                local current_response
                current_response=$(curl -s --show-error -w "\n%{http_code}" \
                  -H "Authorization: Bearer $GANDI_TOKEN" \
                  "$url")

                local http_code body current_values
                http_code=$(echo "$current_response" | tail -n 1)
                body=$(echo "$current_response" | head -n -1)

                if [[ "$http_code" == "404" ]]; then
                  echo "INFO: Creating $subdomain $record_type: $new_values"

                  local create_payload create_response create_http_code create_body
                  create_payload=$(echo "$values_json" | jq --arg name "$subdomain" --arg type "$record_type" '{
                    rrset_ttl: 10800,
                    rrset_values: .
                  }')

                  create_response=$(curl -s --show-error -w "\n%{http_code}" -X POST \
                    -H "Content-Type: application/json" \
                    -H "Authorization: Bearer $GANDI_TOKEN" \
                    -d "$create_payload" \
                    "$url")
                  create_http_code=$(echo "$create_response" | tail -n 1)
                  create_body=$(echo "$create_response" | head -n -1)

                  if [[ "$create_http_code" =~ ^2 ]]; then
                    echo "INFO: Successfully created $subdomain $record_type"
                    return 0
                  else
                    echo "ERROR: Failed to create $subdomain $record_type (HTTP $create_http_code): $create_body" >&2
                    return 1
                  fi
                elif [[ "$http_code" != "200" ]]; then
                  echo "WARN: Could not fetch DNS record for $subdomain $record_type (HTTP $http_code), skipping" >&2
                  return 0
                else
                  current_values=$(echo "$body" | jq -c '.rrset_values // [] | sort')
                fi

                if [[ "$current_values" == "$new_values" ]]; then
                  echo "INFO: $subdomain $record_type is up to date"
                  return 0
                fi

                echo "INFO: Updating $subdomain $record_type: $current_values -> $new_values"

                local update_response update_http_code update_body
                update_response=$(curl -s --show-error -w "\n%{http_code}" -X PUT \
                  -H "Content-Type: application/json" \
                  -H "Authorization: Bearer $GANDI_TOKEN" \
                  -d "$payload" \
                  "$url")
                update_http_code=$(echo "$update_response" | tail -n 1)
                update_body=$(echo "$update_response" | head -n -1)

                if [[ "$update_http_code" =~ ^2 ]]; then
                  echo "INFO: Successfully updated $subdomain $record_type"
                else
                  echo "ERROR: Failed to update $subdomain $record_type (HTTP $update_http_code): $update_body" >&2
                  return 1
                fi
              }

              subdomains=(${lib.escapeShellArgs cfg.subdomain})

              for subdomain in "''${subdomains[@]}"; do
                update_record "$subdomain" "A" "''${ipv4_addrs[@]}"
                update_record "$subdomain" "AAAA" "''${ipv6_addrs[@]}"
              done
            '';
          }
        );
      };
    };

    systemd.timers.gandi-livedns = {
      description = "Gandi LiveDNS Private IP Updater Timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = cfg.interval;
      };
    };
  };
}
