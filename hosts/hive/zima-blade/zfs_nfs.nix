{ name, pkgs, ... }:
{
  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
  services.zfs.trim.enable = true;
  # Accessible via network
  services.nfs.server = {
    enable = true;
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

  # Enable mail notifications
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 587;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "on";
    };
    accounts = {
      zed = {
        host = "smtp.gmail.com";
        passwordeval = "cat /etc/emailpass.txt";
        user = "d.vinternatt@gmail.com";
        from = "zed@${name}.local";
      };
    };
  };
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [
      # "root"
      "zimazfszed.jc5ka@passmail.net"
    ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "-a zed @ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  services.zfs.zed.enableMail = false;
}
