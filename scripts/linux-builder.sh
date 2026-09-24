#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: linux-builder.sh <start|stop|restart> [ssh-port]" >&2
  exit 2
fi

action=$1
port=${2:-31022}
plist=/Library/LaunchDaemons/org.nixos.linux-builder.plist
label=system/org.nixos.linux-builder

is_running() {
  sudo launchctl print "$label" >/dev/null 2>&1
}

wait_for_port() {
  echo "linux-builder: waiting for port $port to accept connections..."
  for _ in $(seq 1 120); do
    if nc -z -w 1 localhost "$port" 2>/dev/null; then
      echo "linux-builder is up on port $port"
      return 0
    fi
    sleep 1
  done
  echo "error: linux-builder did not come up on port $port within 120s" >&2
  return 1
}

case "$action" in
  start)
    if is_running; then
      echo "linux-builder: already running"
    else
      sudo launchctl bootstrap system "$plist"
      echo "linux-builder: started"
    fi
    wait_for_port
    ;;
  stop)
    if is_running; then
      sudo launchctl bootout "$label" &&
        echo "linux-builder: stopped (RAM/disk released; Linux builds fail until 'just start-linux-builder')"
    else
      echo "linux-builder: not running"
    fi
    ;;
  restart)
    # `launchctl kickstart` fails (exit 113) if the service is already down, so
    # tear down the daemon first (no-op if not loaded) and re-spin it from its plist.
    sudo launchctl bootout "$label" 2>/dev/null || true
    sudo launchctl bootstrap system "$plist"
    echo "linux-builder: restarted"
    wait_for_port
    ;;
  *)
    echo "error: unknown action '$action' (expected start, stop or restart)" >&2
    exit 2
    ;;
esac
