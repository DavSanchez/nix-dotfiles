{ config, ... }:

{
  networking.stevenBlack = {
    enable = true;
    block = [ "gambling" ];
    whitelist = [ "example.com" ];
  };

  test = ''
    echo "checking /etc/hosts activation script" >&2
    grep "setting up /etc/hosts" ${config.out}/activate

    echo "checking generated hosts file references stevenblack" >&2
    hostsFile=$(grep -o '/nix/store/[^ ]*-hosts' ${config.out}/activate | head -1)
    echo "generated hosts file: $hostsFile" >&2

    grep "StevenBlack" "$hostsFile"

    echo "checking gambling extension is included" >&2
    grep "StevenBlack/hosts extension gambling" "$hostsFile"

    echo "checking whitelist removes example.com from final output" >&2
    if grep "example.com" "$hostsFile"; then
      echo "FAIL: hosts file still contains example.com" >&2
      exit 1
    fi
    echo "ok: example.com is not in the hosts file" >&2
  '';
}
