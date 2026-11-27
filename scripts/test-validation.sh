#!/usr/bin/env bash

set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd -- "$root"
bash_bin=$BASH
scratch=$(mktemp -d "${TMPDIR:-/tmp}/arm-secnet-validation.XXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
trap 'exit 1' HUP INT TERM

passed=0
failed=0
run_case() {
  local label="$1" expected_status="$2" expected_output="$3" status=0
  shift 3
  "$@" > "$scratch/output" 2>&1 || status=$?
  if [[ "$status" -eq "$expected_status" ]] &&
    grep -Fq -- "$expected_output" "$scratch/output"; then
    printf '[PASS] %s (exit %s)\n' "$label" "$status"
    passed=$((passed + 1))
  else
    printf '[FAIL] %s (exit %s, expected %s; required output: %s)\n' \
      "$label" "$status" "$expected_status" "$expected_output"
    cat "$scratch/output"
    failed=$((failed + 1))
  fi
}

copy="$scratch/validator"
mkdir -p "$copy/scripts"
cp -R README.md LICENSE CONTRIBUTING.md docs "$copy/"
cp scripts/validate-lab.sh "$copy/scripts/"
validator="$copy/scripts/validate-lab.sh"
screenshot=docs/evidence/screenshots/01-arm64-hostnamectl.png
manifest=docs/evidence/historical-screenshot-sha256.txt

cd -- "$scratch"
run_case 'Clean copy from another working directory' 0 'documentation and evidence validation passed' "$bash_bin" "$validator"
run_case 'All 29 required files' 0 'Passed:  29' "$bash_bin" "$validator"
run_case 'All 13 historical hashes' 0 'SHA-256 verified: 13/13' "$bash_bin" "$validator"

rm -- "$copy/$screenshot"
run_case 'Missing screenshot' 1 'Cannot verify missing, empty or non-regular screenshot' "$bash_bin" "$validator"
: > "$copy/$screenshot"
run_case 'Empty screenshot' 1 'Cannot verify missing, empty or non-regular screenshot' "$bash_bin" "$validator"
printf 'changed bytes\n' >> "$copy/$screenshot"
run_case 'Modified screenshot' 1 'SHA-256 mismatch' "$bash_bin" "$validator"
cp -- "$root/$screenshot" "$copy/$screenshot"

rm -- "$copy/$manifest"
run_case 'Missing manifest' 1 'missing, empty or unreadable' "$bash_bin" "$validator"
: > "$copy/$manifest"
run_case 'Empty manifest' 1 'missing, empty or unreadable' "$bash_bin" "$validator"
printf 'invalid entry\n' > "$copy/$manifest"
run_case 'Malformed manifest' 1 'Malformed SHA-256 entry' "$bash_bin" "$validator"
sed '1d' "$root/$manifest" > "$copy/$manifest"
run_case 'Incomplete manifest' 1 'Missing SHA-256 entry' "$bash_bin" "$validator"
cp -- "$root/$manifest" "$copy/$manifest"
sed -n '1p' "$root/$manifest" >> "$copy/$manifest"
run_case 'Duplicate manifest entry' 1 'Duplicate SHA-256 entry' "$bash_bin" "$validator"
sed '1s@  docs/.*@  ../unexpected.png@' "$root/$manifest" > "$copy/$manifest"
run_case 'Unexpected manifest path' 1 'Unexpected screenshot path' "$bash_bin" "$validator"
cp -- "$root/$manifest" "$copy/$manifest"
printf '\000' >> "$copy/$manifest"
run_case 'NUL in manifest' 1 'contains invalid bytes' "$bash_bin" "$validator"
cp -- "$root/$manifest" "$copy/$manifest"

bin="$scratch/bin"
mkdir "$bin"
for utility in dirname cmp tr; do
  ln -s "$(command -v "$utility")" "$bin/$utility"
done
run_case 'Missing SHA-256 tools' 1 'requires sha256sum or shasum' env PATH="$bin" "$bash_bin" "$validator"
if command -v shasum >/dev/null 2>&1; then
  ln -s "$(command -v shasum)" "$bin/shasum"
  run_case 'shasum fallback' 0 'SHA-256 verified: 13/13' env PATH="$bin" "$bash_bin" "$validator"
fi
if command -v sha256sum >/dev/null 2>&1; then
  ln -s "$(command -v sha256sum)" "$bin/sha256sum"
  run_case 'sha256sum primary' 0 'SHA-256 verified: 13/13' env PATH="$bin" "$bash_bin" "$validator"
fi

mkdir "$scratch/git"
cd -- "$scratch/git"
git init -q --object-format=sha1 .
export GIT_AUTHOR_NAME='ARM-SecNet Test' GIT_AUTHOR_EMAIL='test@example.invalid'
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

make_commit() {
  git add -- .
  git commit-tree "$(git write-tree)" "$@" -m 'Disposable validation fixture'
}

printf 'baseline\n' > baseline.txt
initial=$(make_commit)
printf 'clean change\n' > clean.txt
clean=$(make_commit -p "$initial")
printf 'trailing space \n' > bad.txt
bad=$(make_commit -p "$clean")
printf 'last commit is clean\n' > final.txt
last=$(make_commit -p "$bad")

checker="$root/scripts/check-committed-whitespace.sh"
push_check() {
  GITHUB_EVENT_NAME=push PUSH_BEFORE_SHA="$1" PUSH_AFTER_SHA="$2" "$bash_bin" "$checker"
}
pr_check() {
  GITHUB_EVENT_NAME=pull_request PR_BASE_SHA="$1" PR_HEAD_SHA="$2" "$bash_bin" "$checker"
}

run_case 'Clean committed push' 0 'Committed whitespace validation passed' push_check "$initial" "$clean"
run_case 'Committed trailing whitespace' 1 'bad.txt:1: trailing whitespace' push_check "$clean" "$bad"
run_case 'Final commit alone is clean' 0 'Committed whitespace validation passed' push_check "$bad" "$last"
run_case 'Multi-commit push catches earlier whitespace' 1 'bad.txt:1: trailing whitespace' push_check "$initial" "$last"

# Branch from the initial tree and add whitespace only to the base side.
git read-tree "$initial"
printf 'baseline with trailing space \n' > baseline.txt
git add -- baseline.txt
base_only=$(git commit-tree "$(git write-tree)" -p "$initial" -m 'Diverged base fixture')
# The PR contributes only clean.txt. The merge-base range must exclude base-only changes.
run_case 'PR with a diverged base uses the common ancestor' 0 "from $initial to $clean" pr_check "$base_only" "$clean"
run_case 'PR with a diverged base detects PR whitespace' 1 'bad.txt:1: trailing whitespace' pr_check "$base_only" "$bad"

run_case 'Missing before SHA' 1 'base must be a full, nonzero commit SHA' push_check '' "$clean"
run_case 'Invalid PR head SHA' 1 'head must be a full, nonzero commit SHA' pr_check "$initial" '--help'
run_case 'All-zero push SHA' 1 'base must be a full, nonzero commit SHA' push_check '0000000000000000000000000000000000000000' "$clean"
run_case 'Unavailable commit SHA' 1 'could not fetch base commit' push_check '1111111111111111111111111111111111111111' "$clean"
blob=$(git rev-parse "$initial:baseline.txt")
run_case 'Existing SHA for a non-commit object' 1 'is not a commit' push_check "$blob" "$clean"

# Exercise the missing-object fetch path with a local origin.
git update-ref refs/heads/main "$last"
mkdir "$scratch/fetch"
git -C "$scratch/fetch" init -q --object-format=sha1 .
git -C "$scratch/fetch" remote add origin "$scratch/git"
cd -- "$scratch/fetch"
run_case 'Fetch missing event commits from origin' 0 'Committed whitespace validation passed' push_check "$initial" "$clean"

check_relative_links() {
  local file line target remaining link_pattern='\]\(([^ )]+)\)' count=0 broken=0
  while IFS= read -r -d '' file; do
    while IFS= read -r line || [[ -n "$line" ]]; do
      remaining=$line
      while [[ "$remaining" =~ $link_pattern ]]; do
        target=${BASH_REMATCH[1]}
        remaining=${remaining#*"${BASH_REMATCH[0]}"}
        case "$target" in
          *://*|mailto:*|/*|'#'*) continue ;;
        esac
        target=${target%%#*}
        count=$((count + 1))
        if [[ ! -e "$root/$(dirname -- "$file")/$target" ]]; then
          printf 'Broken link in %s: %s\n' "$file" "$target"
          broken=$((broken + 1))
        fi
      done
    done < "$root/$file"
  done < <(git -C "$root" ls-files -z -- '*.md')
  printf 'Relative Markdown targets: %s checked, %s broken\n' "$count" "$broken"
  [[ "$count" -gt 0 && "$broken" -eq 0 ]]
}

run_case 'Relative Markdown link targets' 0 ', 0 broken' check_relative_links
# Report the count as well as the case result.
cat "$scratch/output"
printf 'Regression cases: %s passed, %s failed\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
