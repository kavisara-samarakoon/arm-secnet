#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

fail() {
  printf 'Whitespace validation failed: %s\n' "$*" >&2
  exit 1
}

validate_sha() {
  local label="$1" sha="$2"
  [[ "$sha" =~ ^[0-9a-f]{40}$ && "$sha" != 0000000000000000000000000000000000000000 ]] ||
    fail "$label must be a full, nonzero commit SHA"
}

ensure_commit() {
  local label="$1" sha="$2" object_type
  if ! git cat-file -e "$sha" 2>/dev/null; then
    git fetch --no-tags origin "$sha" ||
      fail "could not fetch $label commit $sha"
  fi
  object_type=$(git cat-file -t "$sha" 2>/dev/null) ||
    fail "$label object $sha is unavailable"
  [[ "$object_type" == commit ]] || fail "$label object $sha is not a commit"
}

case "${GITHUB_EVENT_NAME:-}" in
  pull_request)
    base=${PR_BASE_SHA:-}
    head=${PR_HEAD_SHA:-}
    ;;
  push)
    base=${PUSH_BEFORE_SHA:-}
    head=${PUSH_AFTER_SHA:-}
    ;;
  *)
    fail "unsupported or missing event"
    ;;
esac

validate_sha "base" "$base"
validate_sha "head" "$head"
[[ "$(git rev-parse --is-shallow-repository)" == false ]] ||
  fail "full Git history is required"
ensure_commit "base" "$base"
ensure_commit "head" "$head"

if [[ "$GITHUB_EVENT_NAME" == pull_request ]]; then
  base=$(git merge-base --all "$base" "$head") ||
    fail "could not determine the PR merge base"
  [[ "$base" =~ ^[0-9a-f]{40}$ ]] || fail "PR comparison has no unique merge base"
fi

printf 'Checking committed whitespace from %s to %s\n' "$base" "$head"
git diff --no-ext-diff --no-textconv --check "$base" "$head" -- ||
  fail "git diff --check rejected the committed range"
echo "Committed whitespace validation passed."
