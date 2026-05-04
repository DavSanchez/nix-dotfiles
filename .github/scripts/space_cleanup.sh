#!/usr/bin/env bash

set -e

# Got this from <https://github.com/newrelic/infrastructure-publish-action/blob/ecba9f25fc8c7badc3c4e7d2c2aed51c26d52f2b/action-run.sh#L22>
df -h /

echo "free up space"

sudo rm -rf /usr/local/lib/android
sudo rm -rf /usr/lib/jvm
sudo rm -rf /usr/local/share/powershell
sudo rm -rf /usr/share/dotnet
sudo rm -rf /usr/local/.ghcup
sudo rm -rf /opt/hostedtoolcache/CodeQL
sudo rm -rf /opt/hostedtoolcache/Python
sudo rm -rf /usr/share/swift
sudo rm -rf "$AGENT_TOOLSDIRECTORY"

df -h /
