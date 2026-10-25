#!/usr/bin/env bash
# Bump a tag-pinned flake input to the repository's latest GitHub release,
# refresh its lock entry, and open (or refresh) an auto-merging PR.
#
# Dependabot's nix tag updater picks the tag *below* the current one when the
# pin is already the latest (#786, #788), so tag-pinned inputs are ignored in
# .github/dependabot.yml and handled here instead.
#
# Usage: update-flake-tag.sh <input> <owner/repo>
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: update-flake-tag.sh <input> <owner/repo>" >&2
  exit 2
fi
input=$1
repo=$2

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

# Restore flake.nix/flake.lock if a step fails before the commit lands.
backup=$(mktemp -d)
cp flake.nix flake.lock "$backup/"
restore() {
  cp "$backup/flake.nix" "$backup/flake.lock" . || true
  rm -rf "$backup"
}
trap restore ERR

# Returns 0 when the first vMAJOR.MINOR.PATCH tag is newer than the second.
is_newer() {
  local IFS=.
  local -a cur_parts new_parts
  read -r -a cur_parts <<< "${2#v}"
  read -r -a new_parts <<< "${1#v}"
  local i
  for i in 0 1 2; do
    if ((10#${new_parts[i]:-0} > 10#${cur_parts[i]:-0})); then return 0; fi
    if ((10#${new_parts[i]:-0} < 10#${cur_parts[i]:-0})); then return 1; fi
  done
  return 1
}

latest=$(gh api "repos/$repo/releases/latest" --jq .tag_name)

# Hermes used to publish date-style tags (v2026.9.24 = v0.21.5). They sort
# above v0.22.x and must never be picked.
if [[ $latest =~ ^v[0-9]{4}\. ]]; then
  echo "$input: skipping date-style tag $latest"
  exit 0
fi

current=$(sed -n "s|^[[:space:]]*$input\.url = \"github:$repo/\([^/\"]*\)\";|\1|p" flake.nix)
if [[ -z $current ]]; then
  echo "$input: not a tag-pinned input in flake.nix" >&2
  exit 1
fi

if [[ $latest == "$current" ]]; then
  echo "$input: already on $current"
  exit 0
fi

if ! is_newer "$latest" "$current"; then
  echo "$input: $latest is not newer than $current"
  exit 0
fi

echo "$input: $current -> $latest"
sed -i.bak "s|github:$repo/$current|github:$repo/$latest|" flake.nix
rm -f flake.nix.bak
nix flake update "$input"

branch="update/flake-$input"
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git checkout -B "$branch"
git add flake.nix flake.lock
git commit -m "chore(deps): bump $input to $latest"
trap - ERR
rm -rf "$backup"
git push --force origin "$branch"

title="chore(deps): bump $input to $latest"
body="Automated update of the tag-pinned \`$input\` flake input to \`$latest\`, the latest GitHub release."
pr=$(gh pr list --head "$branch" --json number --jq '.[0].number // empty')
if [[ -n $pr ]]; then
  gh pr edit "$pr" --title "$title" --body "$body"
else
  gh pr create --title "$title" --body "$body" --base master --head "$branch"
fi
gh pr merge --auto --squash "$branch"
