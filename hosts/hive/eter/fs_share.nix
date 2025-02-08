_: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "hosts allow" = "192.168.8. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
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
