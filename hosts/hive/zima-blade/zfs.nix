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
