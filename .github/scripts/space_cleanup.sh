#!/usr/bin/env bash

# Got this from <https://github.com/newrelic/infrastructure-publish-action/blob/ecba9f25fc8c7badc3c4e7d2c2aed51c26d52f2b/action-run.sh#L22>
df -h /

echo "free up space"

# Use `|| true` so missing paths or read-only filesystems (e.g. /usr/share/swift
# on the macos-26-arm64 image) don't abort the whole job.
sudo rm -rf /usr/local/lib/android || true
sudo rm -rf /usr/lib/jvm || true
sudo rm -rf /usr/local/share/powershell || true
sudo rm -rf /usr/share/dotnet || true
sudo rm -rf /usr/local/.ghcup || true
sudo rm -rf /opt/hostedtoolcache/CodeQL || true
sudo rm -rf /opt/hostedtoolcache/Python || true
sudo rm -rf /usr/share/swift || true
sudo rm -rf "$AGENT_TOOLSDIRECTORY" || true

df -h /
