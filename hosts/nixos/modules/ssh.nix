_: {
  services.openssh = {
    enable = true;
    # Don't open 22 on every interface; the source-restricted rule below limits
    # it to the private LAN and tailnet.
    openFirewall = false;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  networking.firewall.extraInputRules = ''
    ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10 } tcp dport 22 accept
    ip6 saddr fc00::/7 tcp dport 22 accept
  '';
}
