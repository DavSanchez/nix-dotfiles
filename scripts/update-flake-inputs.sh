#!/usr/bin/env bash
#
# update-flake-inputs.sh
#
# Open a PR per nix flake input that has an upstream update, then enable
# automerge on it. Mirrors the manual workflow:
#
#   branch update/<input> -> nix flake update <input> -> commit (signed)
#   -> push -> gh pr create -> gh pr merge --auto --squash
#
# Usage:
#   scripts/update-flake-inputs.sh [INPUT ...]   update one or more named inputs
#   scripts/update-flake-inputs.sh --all          update every top-level input that has an update
#   scripts/update-flake-inputs.sh --check        dry-run: list inputs with updates, change nothing
#
# The repo's master is protected by a ruleset requiring signed commits and the
# four aggregate CI checks, so every commit is made with `git commit -S` and
# automerge is enabled so the PR merges as soon as CI goes green.

set -euo pipefail

REMOTE="origin"
BASE="master"

usage() {
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

# Top-level flake inputs: lines of the form `    <name>.url = "..."` in the
# inputs block. Comments and nested `foo.inputs.bar.follows` lines are skipped.
top_level_inputs() {
  awk '
    /^[[:space:]]*#/ { next }
    /\.url[[:space:]]*=/ {
      line = $0
      sub(/^[[:space:]]*/, "", line)
      sub(/\..*$/, "", line)
      print line
    }
  ' flake.nix | sort -u
}

# Locked revision (or tarball lastModified) for an input, from flake.lock.
locked_rev() {
  nix flake metadata --json 2>/dev/null \
    | python3 -c 'import json,sys
d=json.load(sys.stdin)
n=d["locks"]["nodes"].get(sys.argv[1],{}).get("locked",{})
print(n.get("rev") or n.get("lastModified",""))' "$1"
}

# Does `nix flake update <input>` change flake.lock? Runs the update then
# restores the lockfile, so it is side-effect free.
input_has_update() {
  local input="$1"
  nix flake update "$input" >/dev/null 2>&1
  local changed=1
  git diff --quiet -- flake.lock || changed=0
  git checkout -- flake.lock 2>/dev/null || true
  return $changed
}

update_one() {
  local input="$1"
  local branch="update/$input"

  if ! input_has_update "$input"; then
    echo "  $input: no update available, skipping"
    return 0
  fi
  echo "  $input: update available"

  if [ "$CHECK" -eq 1 ]; then
    echo "  $input: (dry-run) would create branch '$branch', commit, push, PR + automerge"
    return 0
  fi

  git checkout -B "$branch" "$REMOTE/$BASE" >/dev/null 2>&1
  nix flake update "$input" >/dev/null 2>&1

  git add flake.lock
  git commit -S -m "chore: update $input flake input" >/dev/null
  echo "  $input: committed $(git rev-parse --short HEAD) (signed)"
  git push -u "$REMOTE" "$branch" >/dev/null 2>&1

  local pr_url pr_num
  pr_url=$(gh pr create --base "$BASE" --head "$branch" \
    --title "chore: update $input flake input" \
    --body "Update the \`$input\` flake input via \`nix flake update $input\`." 2>&1 | tail -1)
  pr_num=$(echo "$pr_url" | grep -oE '[0-9]+$' || true)
  gh pr merge "$pr_num" --auto --squash >/dev/null 2>&1
  echo "  $input: PR $pr_url (automerge enabled)"

  git checkout "$BASE" >/dev/null 2>&1
}

CHECK=0
ARGS=()

for arg in "$@"; do
  case "$arg" in
    --check) CHECK=1 ;;
    --all)   ARGS+=("ALL") ;;
    -h|--help) usage ;;
    *)       ARGS+=("$arg") ;;
  esac
done

if [ "$CHECK" -eq 1 ]; then
  echo "Top-level flake inputs:"
  for i in $(top_level_inputs); do
    if input_has_update "$i"; then
      echo "  $i: UPDATE AVAILABLE (locked $(locked_rev "$i" | cut -c1-12))"
    else
      echo "  $i: up to date"
    fi
  done
  exit 0
fi

if [ "${#ARGS[@]}" -eq 0 ]; then
  echo "error: specify at least one input, --all, or --check" >&2
  usage
fi

# Safety: refuse to run against a dirty working tree or a non-master checkout.
if [ "$(git symbolic-ref --short HEAD)" != "$BASE" ]; then
  echo "error: must be on '$BASE' to run (currently on $(git symbolic-ref --short HEAD))" >&2
  exit 1
fi
if ! git diff --quiet; then
  echo "error: working tree is dirty; commit or stash first" >&2
  exit 1
fi
git fetch "$REMOTE" "$BASE" >/dev/null 2>&1

if [ "${ARGS[0]}" = "ALL" ] && [ "${#ARGS[@]}" -eq 1 ]; then
  echo "Checking all top-level inputs for updates..."
  for i in $(top_level_inputs); do
    update_one "$i"
  done
else
  for i in "${ARGS[@]}"; do
    if [ "$i" = "ALL" ]; then
      echo "error: --all cannot be combined with named inputs" >&2
      exit 1
    fi
    update_one "$i"
  done
fi

echo "Done."
