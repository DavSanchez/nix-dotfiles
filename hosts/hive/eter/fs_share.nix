_: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "hosts allow" = "192.168.8. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        writeable = "no";
      };
      # Shares
      creation.path = "/seclusium/creation";
      dimensions.path = "/seclusium/dimensions";
      echoes.path = "/seclusium/echoes";
      imagery.path = "/seclusium/imagery";
      technique.path = "/seclusium/technique";
      zg.path = "/seclusium/zg";
    };
  };
}
