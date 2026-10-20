{ pkgs, config, ... }:
{
  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # zfs_arc_max defaults to 0 ("automatic"), which on this host let the ARC
  # target ~14.5 GiB of the 15.5 GiB RAM (arcstats c_max); growing ARC squeezes
  # anonymous pages into swap. 6 GiB leaves headroom for Jellyfin/*arr/qBittorrent.
  # Tradeoff: fewer cached blocks, so more reads hit the pool on cache misses.
  boot.extraModprobeConfig = "options zfs zfs_arc_max=6442450944";

  # vm.swappiness defaults to 60, which lets the kernel swap out anonymous
  # (application) memory rather than only reclaiming page cache. 10 keeps idle
  # service pages resident when the ARC grows; the tradeoff is that file-cache
  # pages (Samba/NFS/Caddy) may be evicted sooner.
  boot.kernel.sysctl."vm.swappiness" = 10;

  # Application state lives on the pool but outside the user-owned media tree,
  # so systemd-tmpfiles can create service-owned directories safely.
  fileSystems."/srv/appdata" = {
    device = "seclusium/appdata";
    fsType = "zfs";
  };

  systemd.tmpfiles.rules = [ "d /srv/appdata 0755 root root -" ];

  # appdata holds the *arr/Navidrome SQLite databases, where 1 MiB records cause
  # read-modify-write amplification; 64 KiB matches their small random I/O.
  # Set once with `zfs set recordsize=64K seclusium/appdata`: the property lives
  # in the pool, so it survives reboots without an activation step (re-run it
  # only if the dataset is recreated). Existing blocks keep their old size until
  # rewritten. (/seclusium/zg stays at 1 MiB: it also holds 29 GiB of large
  # sequential qBittorrent downloads.)
  # `recordsize` is a dataset property, not a mount option, so it cannot go in
  # fileSystems.*.options.
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
        passwordeval = "cat ${config.sops.secrets.zfs_mail_pass.path}";
        user = "d.vinternatt@gmail.com";
        from = "zed@eter.local";
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
