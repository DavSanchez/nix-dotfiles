_: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "hosts allow" = "192.168.8. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";

        # Enhanced OSX interoperability: https://www.samba.org/samba/docs/current/man-html/vfs_fruit.8.html
        # Some file names with special characters do not show when mounted in macOS (shrug/facepalm).
        # The configs below fix it.
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:resource" = "file";
        "fruit:metadata" = "netatalk";
        "fruit:locking" = "netatalk";
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
        "hosts allow" = "192.168.8.102";
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
