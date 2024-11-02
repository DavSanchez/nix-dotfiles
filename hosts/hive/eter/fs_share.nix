_: {
  # Accessible via network
  services.nfs.server = {
    enable = false;
    # fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    # extraNfsdConfig = '''';
    # see `man exports` for option details
    exports = ''
      /seclusium 192.168.8.0/24(fsid=0,no_subtree_check)

      /seclusium/creation 192.168.8.0/24(rw,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /seclusium/dimensions 192.168.8.0/24(no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /seclusium/echoes 192.168.8.0/24(rw,no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /seclusium/imagery 192.168.8.0/24(no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /seclusium/technique 192.168.8.0/24(no_subtree_check,all_squash,anonuid=1000,anongid=100)
      /seclusium/zg 192.168.8.0/24(no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };

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
        writeable = "yes";
      };
      dimensions = {
        path = "/seclusium/dimensions";
        writeable = "no";
      };
      echoes = {
        path = "/seclusium/echoes";
        writeable = "yes";
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
