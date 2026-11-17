#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${JUST_TRACE:-}" ]]; then set -x; fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: linux-builder.sh <start|stop|restart|logs> [ssh-port]" >&2
  exit 2
fi

action=$1
port=${2:-31022}
plist=/Library/LaunchDaemons/org.nixos.linux-builder.plist
label=system/org.nixos.linux-builder

is_running() {
  sudo launchctl print "$label" >/dev/null 2>&1
}

port_open() {
  nc -z -w 1 localhost "$port" 2>/dev/null
}

# A bare TCP connect is not enough: QEMU's port forward accepts connections as
# soon as the process starts, before the guest's sshd is up. Wait for the banner.
ssh_ready() {
  local banner
  # Keep stdin open (sleep): with `</dev/null` nc sees EOF and closes the socket
  # before sshd's banner arrives, so the probe would never succeed.
  banner=$( (sleep 2) | nc -w 3 localhost "$port" 2>/dev/null | head -n 1 || true)
  [[ $banner == SSH-* ]]
}

# `launchctl bootout` can return before QEMU has exited and released the port.
wait_for_port_down() {
  for _ in $(seq 1 60); do
    port_open || return 0
    sleep 1
  done
  echo "error: port $port still in use 60s after stopping linux-builder" >&2
  lsof -nP -iTCP:"$port" -sTCP:LISTEN >&2 || true
  return 1
}

# Dump what we know so a failure is diagnosable instead of silent. The guest
# console (vzvm "log" mode) goes to the unified log, not to a file.
diagnose() {
  {
    echo "--- launchd state ---"
    sudo launchctl print "$label" 2>&1 | grep -E 'state =|pid =|runs =|last exit' || echo "(not loaded)"
    echo "--- guest console (last 40 lines, unified log, last 5m) ---"
    /usr/bin/log show --last 5m --style compact \
      --predicate 'process == "vzvm" OR subsystem == "systems.applicative.vzvm"' 2>&1 | tail -n 40
  } >&2
}

wait_for_port() {
  echo "linux-builder: waiting for sshd on port $port..."
  for _ in $(seq 1 120); do
    if ssh_ready; then
      echo "linux-builder is up on port $port"
      return 0
    fi
    sleep 1
  done
  echo "error: linux-builder did not come up on port $port within 120s" >&2
  diagnose
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
    echo "linux-builder: stopping..."
    sudo launchctl bootout "$label" || echo "linux-builder: bootout failed or not loaded (continuing)" >&2
    wait_for_port_down
    echo "linux-builder: bootstrapping $plist"
    sudo launchctl bootstrap system "$plist"
    echo "linux-builder: restarted"
    wait_for_port
    ;;
  logs)
    exec /usr/bin/log stream --style compact --predicate 'process == "vzvm"'
    ;;
  *)
    echo "error: unknown action '$action' (expected start, stop, restart or logs)" >&2
    exit 2
    ;;
esac
