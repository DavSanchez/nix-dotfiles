{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gandi-ddns;
  tsEnabled = config.services.tailscale.enable;
in
{
  options.services.gandi-ddns = {
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
      type = lib.types.str;
      description = ''
        Subdomain to update (e.g. "*.mora" or "mora").
        The record will point to this host's private local IPs and Tailscale IP(s).
      '';
      example = "*.mora";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "5min";
      description = "Systemd timer OnUnitActiveSec interval.";
      example = "10min";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gandi-ddns = {
      description = "Gandi LiveDNS Private IP Updater";
      after = [ "network-online.target" ] ++ lib.optional tsEnabled "tailscaled.service";
      wants = [ "network-online.target" ] ++ lib.optional tsEnabled "tailscaled.service";
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        LoadCredential = [ "gandi_token:${cfg.tokenFile}" ];
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "gandi-ddns";
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

              get_local_ipv4() {
                ip -json addr show |
                  jq -r '
                    [
                      .[] |
                      select(
                        .ifname != "lo" and
                        (.ifname | startswith("docker") | not) and
                        (.ifname | startswith("veth") | not) and
                        (.ifname | startswith("br-") | not) and
                        (.ifname | startswith("tailscale") | not) and
                        (.ifname | startswith("utun") | not)
                      ) |
                      .addr_info[] |
                      select(.family == "inet" and .scope == "global") |
                      .local
                    ] |
                    map(
                      split(".") |
                      select(
                        .[0] == "10" or
                        (.[0] == "172" and (.[1] | tonumber) >= 16 and (.[1] | tonumber) <= 31) or
                        (.[0] == "192" and .[1] == "168")
                      ) |
                      join(".")
                    ) |
                    unique |
                    .[]
                  ' 2>/dev/null
              }

              get_local_ipv6() {
                ip -json addr show |
                  jq -r '
                    [
                      .[] |
                      select(
                        .ifname != "lo" and
                        (.ifname | startswith("docker") | not) and
                        (.ifname | startswith("veth") | not) and
                        (.ifname | startswith("br-") | not) and
                        (.ifname | startswith("tailscale") | not) and
                        (.ifname | startswith("utun") | not)
                      ) |
                      .addr_info[] |
                      select(.family == "inet6" and .scope == "global") |
                      .local
                    ] |
                    map(
                      select(
                        (startswith("fc") or startswith("fd")) and
                        (startswith("fe80:") | not)
                      )
                    ) |
                    unique |
                    .[]
                  ' 2>/dev/null
              }

              ${lib.optionalString tsEnabled ''
                get_tailscale_ipv4() {
                  ip -json addr show tailscale0 2>/dev/null |
                    jq -r '
                      [
                        .[] |
                        .addr_info[] |
                        select(.family == "inet" and .scope == "global") |
                        .local
                      ] |
                      map(
                        split(".") |
                        select(.[0] == "100" and (.[1] | tonumber) >= 64 and (.[1] | tonumber) <= 127) |
                        join(".")
                      ) |
                      unique |
                      .[]
                    ' 2>/dev/null || true
                }

                get_tailscale_ipv6() {
                  ip -json addr show tailscale0 2>/dev/null |
                    jq -r '
                      [
                        .[] |
                        .addr_info[] |
                        select(.family == "inet6" and .scope == "global") |
                        .local
                      ] |
                      map(select(startswith("fd7a:115c:a1e0"))) |
                      unique |
                      .[]
                    ' 2>/dev/null || true
                }
              ''}

              update_record() {
                local record_type="$1"
                shift
                local ips=("$@")
                local subdomain="${cfg.subdomain}"
                local url="$API_BASE/$subdomain/$record_type"

                if [[ ''${#ips[@]} -eq 0 ]]; then
                  echo "WARN: No $record_type IPs found, skipping $subdomain" >&2
                  return 0
                fi

                local payload
                payload=$(printf '%s\n' "''${ips[@]}" | jq -R . | jq -s '{rrset_ttl: 300, rrset_values: .}')

                local current_response
                current_response=$(curl -s -w "\n%{http_code}" \
                  -H "Authorization: Bearer $GANDI_TOKEN" \
                  "$url" 2>/dev/null || true)

                local http_code
                http_code=$(echo "$current_response" | tail -n 1)
                local body
                body=$(echo "$current_response" | head -n -1)

                local current_values
                if [[ "$http_code" == "404" ]]; then
                  current_values="[]"
                elif [[ "$http_code" != "200" ]]; then
                  echo "WARN: Could not fetch DNS record for $subdomain $record_type (HTTP $http_code), skipping" >&2
                  return 0
                else
                  current_values=$(echo "$body" | jq -c '.rrset_values // [] | sort')
                fi

                local new_values
                new_values=$(printf '%s\n' "''${ips[@]}" | jq -R . | jq -sc 'sort')

                if [[ "$current_values" == "$new_values" ]]; then
                  echo "INFO: $subdomain $record_type is up to date"
                  return 0
                fi

                echo "INFO: Updating $subdomain $record_type: $current_values -> $new_values"

                if curl -s --fail -X PUT \
                  -H "Content-Type: application/json" \
                  -H "Authorization: Bearer $GANDI_TOKEN" \
                  -d "$payload" \
                  "$url" >/dev/null 2>&1; then
                  echo "INFO: Successfully updated $subdomain $record_type"
                else
                  echo "ERROR: Failed to update $subdomain $record_type" >&2
                  return 1
                fi
              }

              mapfile -t ipv4_addrs < <(get_local_ipv4${lib.optionalString tsEnabled "; get_tailscale_ipv4"})
              mapfile -t ipv6_addrs < <(get_local_ipv6${lib.optionalString tsEnabled "; get_tailscale_ipv6"})

              update_record "A" "''${ipv4_addrs[@]}"
              update_record "AAAA" "''${ipv6_addrs[@]}"
            '';
          }
        );
      };
    };

    systemd.timers.gandi-ddns = {
      description = "Gandi LiveDNS Private IP Updater Timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = cfg.interval;
      };
    };
  };
}
