#!/usr/bin/env bash
# Blocks Bash commands that could decrypt secrets/secrets.yaml into this session's
# context. `.gitattributes` sets `diff=sopsdiffer` for *.yaml and the user's global
# ~/.gitconfig sets `diff.sopsdiffer.textconv = sops decrypt`, so any git plumbing
# that computes a diff/patch for that file (diff, show, log -p, stash show) prints
# plaintext secrets to stdout. Direct sops decrypt/exec-env/exec-file calls do too.
set -euo pipefail

input="$(cat)"
command="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' | head -1)"

if [[ -z "$command" ]]; then
  exit 0
fi

if printf '%s' "$command" | grep -qiE 'secrets/secrets\.ya?ml' \
  && printf '%s' "$command" | grep -qE '\bgit\b.*(diff|show|log|stash[[:space:]]+show)\b|\b(diff|show|log|stash)\b.*\bgit\b'; then
  echo "Blocked: this command would run git diff/show/log against secrets/secrets.yaml, which auto-decrypts via the sopsdiffer textconv filter and would print plaintext secrets into this session. Use 'git status' or 'sops -e' metadata-only checks instead." >&2
  exit 2
fi

if printf '%s' "$command" | grep -qE '\bsops\b.*(-d\b|--decrypt\b|\bdecrypt\b|exec-env|exec-file)'; then
  echo "Blocked: this command decrypts a sops-managed secret to stdout/env, which would print plaintext secrets into this session." >&2
  exit 2
fi

exit 0
