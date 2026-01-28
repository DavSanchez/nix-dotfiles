#!/bin/bash

set -e

## Freeing space since 14GB are not enough anymore
# Got this from <https://github.com/newrelic/infrastructure-publish-action/blob/ecba9f25fc8c7badc3c4e7d2c2aed51c26d52f2b/action-run.sh#L22>
df -ih
df -h
echo "Deleting android, dotnet, haskell, CodeQL, Python, swift to free up space"
sudo rm -rf /usr/local/lib/android /usr/share/dotnet /usr/local/.ghcup /opt/hostedtoolcache/CodeQL /opt/hostedtoolcache/Python /usr/share/swift
df -ih
df -h
