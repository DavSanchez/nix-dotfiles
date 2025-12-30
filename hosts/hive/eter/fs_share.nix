_: {
  services.samba = {
    enable = true;
    openFirewall = true;
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
      };
      # Shares
      creation = {
        path = "/seclusium/creation";
        writeable = "no";
      };
      dimensions = {
        path = "/seclusium/dimensions";
        writeable = "no";
      };
      echoes = {
        path = "/seclusium/echoes";
        writeable = "yes";
        "hosts allow" = "192.168.0.228";
      };
      imagery = {
        path = "/seclusium/imagery";
        writeable = "no";
      };
      technique = {
        path = "/seclusium/technique";
        writeable = "no";
      };
      zg = {
        path = "/seclusium/zg";
        writeable = "no";
      };
    };
  };
}
