_: {
  services.samba = {
    enable = true;
    # Don't open the Samba ports on every interface; only the private LAN and
    # tailnet may reach them (and `hosts allow` remains a second layer).
    openFirewall = false;
    settings = {
      global = {
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        # "mangled names" = "no";
        # "dos charset" = "CP850";
        # "unix charset" = "UTF-8";
        # macOS compatibility settings (also ran `convmv` to convert filenames to UTF-8)
        "vfs objects" = "fruit catia streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:encoding" = "native";

        writeable = "yes"; # Fine-tune when needed
      };
      # Shares
      creation.path = "/seclusium/creation";
      dimensions.path = "/seclusium/dimensions";
      echoes.path = "/seclusium/echoes";
      imagery.path = "/seclusium/imagery";
      technique.path = "/seclusium/technique";
      zg = {
        path = "/seclusium/zg";
        writeable = "no";
      };
    };
  };

  networking.firewall.extraInputRules = ''
    ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10 } tcp dport { 139, 445 } accept
    ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10 } udp dport { 137, 138 } accept
  '';
}
