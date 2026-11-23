# SSH hosts opened from sierpe ("Connect via SSH" writes these into
# settings.json). Host-scoped on purpose: importing this on another machine
# would advertise a solio connection that may not be reachable from there.
# No `projects` list: those paths are per-workspace state that moves or
# disappears, so they stay out of the declared config.
{
  programs.zed-editor.userSettings.ssh_connections = [
    {
      host = "solio";
      username = "david";
      args = [ ];
    }
  ];
}
