{ config, ... }:
{
  # lima/colima config for writable mounts: https://github.com/abiosoft/colima/issues/83#issuecomment-1339269542
  home.file.".colima/_lima/_config/override.yaml".text = ''
    mountType: 9p
    mounts:
      - location: "/Users/${config.home.username}"
        writable: true
        9p:
          securityModel: mapped-xattr
          cache: mmap
      - location: "~"
        writable: true
        9p:
          securityModel: mapped-xattr
          cache: mmap
      - location: /tmp/colima
        writable: true
        9p:
          securityModel: mapped-xattr
          cache: mmap
  '';
}
