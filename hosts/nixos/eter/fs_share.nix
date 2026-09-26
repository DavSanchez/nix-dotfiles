_: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        # LAN is IPv4; the tailnet is 100.64.0.0/10 (IPv4 CGNAT) plus its
        # IPv6 ULA fd7a:115c:a1e0::/48. Everything else, IPv6 included, is denied.
        "hosts allow" = "192.168.0. 127.0.0.1 localhost 100.64.0.0/10 fd7a:115c:a1e0::/48";
        "hosts deny" = "0.0.0.0/0 ::/0";
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
}
