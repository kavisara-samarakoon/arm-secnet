#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd -- "$repo_root"
export LC_ALL=C

pass_count=0
warn_count=0
fail_count=0

check_required_file() {
  local file_path="$1"

  if [[ -s "$file_path" ]]; then
    echo "[PASS] $file_path exists and is not empty"
    pass_count=$((pass_count + 1))
  else
    echo "[FAIL] $file_path is missing or empty"
    fail_count=$((fail_count + 1))
  fi
}

check_screenshot_integrity() {
  local manifest="docs/evidence/historical-screenshot-sha256.txt"
  local entry_pattern='^([0-9A-Fa-f]{64})  (.+)$'
  local line digest path index found output line_number=0 manifest_errors=0
  local -a digests hash_command

  integrity_expected=${#screenshots[@]}
  if [[ ! -f "$manifest" || ! -s "$manifest" || ! -r "$manifest" ]]; then
    echo "[FAIL] $manifest is missing, empty or unreadable"
    return 1
  fi
  if ! cmp -s "$manifest" <(tr -d '\000' < "$manifest"); then
    echo "[FAIL] $manifest contains invalid bytes or could not be read"
    return 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line_number=$((line_number + 1))
    if [[ ! "$line" =~ $entry_pattern ]]; then
      echo "[FAIL] Malformed SHA-256 entry at $manifest:$line_number"
      manifest_errors=1
      continue
    fi
    digest=$(printf '%s' "${BASH_REMATCH[1]}" | tr 'A-F' 'a-f')
    path=${BASH_REMATCH[2]}
    found=0
    for index in "${!screenshots[@]}"; do
      if [[ "$path" == "${screenshots[index]}" ]]; then
        found=1
        if [[ -n "${digests[index]:-}" ]]; then
          echo "[FAIL] Duplicate SHA-256 entry for $path"
          manifest_errors=1
        fi
        digests[index]=$digest
        break
      fi
    done
    if [[ "$found" -eq 0 ]]; then
      echo "[FAIL] Unexpected screenshot path at $manifest:$line_number"
      manifest_errors=1
    fi
  done < "$manifest"
  for index in "${!screenshots[@]}"; do
    if [[ -z "${digests[index]:-}" ]]; then
      echo "[FAIL] Missing SHA-256 entry for ${screenshots[index]}"
      manifest_errors=1
    fi
  done
  [[ "$manifest_errors" -eq 0 ]] || return 1

  if command -v sha256sum >/dev/null 2>&1; then
    hash_command=(sha256sum)
  elif command -v shasum >/dev/null 2>&1; then
    hash_command=(shasum -a 256)
  else
    echo "[FAIL] SHA-256 verification requires sha256sum or shasum"
    return 1
  fi

  for index in "${!screenshots[@]}"; do
    path=${screenshots[index]}
    if [[ ! -f "$path" || ! -s "$path" ]]; then
      echo "[FAIL] Cannot verify missing, empty or non-regular screenshot: $path"
    elif ! output=$("${hash_command[@]}" < "$path"); then
      echo "[FAIL] SHA-256 command failed for $path"
    elif [[ "${output%% *}" != "${digests[index]}" ]]; then
      echo "[FAIL] SHA-256 mismatch for $path"
    else
      echo "[PASS] SHA-256 verified for $path"
      integrity_passed=$((integrity_passed + 1))
    fi
  done
  [[ "$integrity_passed" -eq "$integrity_expected" ]]
}

echo "ARM-SecNet Documentation and Evidence Validation"
echo "================================================"
echo

echo "Core project files:"
echo

check_required_file "README.md"
check_required_file "LICENSE"
check_required_file "CONTRIBUTING.md"

echo
echo "Core documentation:"
echo

check_required_file "docs/overview.md"
check_required_file "docs/safety.md"
check_required_file "docs/topology.md"

echo
echo "V1 setup guides:"
echo

check_required_file "docs/setup/macos-utm-setup.md"
check_required_file "docs/setup/arm64-linux-vm-setup.md"

echo
echo "V1 labs:"
echo

check_required_file "docs/labs/lab-01-linux-baseline.md"
check_required_file "docs/labs/lab-02-auth-log-analysis.md"

echo
echo "V1 review and evidence:"
echo

check_required_file "docs/lecturer-summary.md"
check_required_file "docs/v1-test-notes.md"
check_required_file "docs/evidence/v1-screenshots.md"
check_required_file "docs/demo/v1-demo-script.md"

echo
echo "V1.1 optional lab documentation and runtime record:"
echo

check_required_file "docs/labs/lab-03-sentinellite-dashboard.md"
check_required_file "docs/evidence/v1.1-sentinellite-dashboard.md"

echo
echo "Historical screenshot files:"
echo

# Keep presence checks and the manifest allowlist in sync.
screenshots=(
  "docs/evidence/screenshots/01-arm64-hostnamectl.png"
  "docs/evidence/screenshots/02-network-shared-nat.png"
  "docs/evidence/screenshots/03-lab01-system-baseline.png"
  "docs/evidence/screenshots/04-lab01-users-processes.png"
  "docs/evidence/screenshots/05-auth-log-sudo-activity.png"
  "docs/evidence/screenshots/v1.1-sentinellite/01-vm-prerequisites.png"
  "docs/evidence/screenshots/v1.1-sentinellite/02-sentinellite-source.png"
  "docs/evidence/screenshots/v1.1-sentinellite/03-doctor.png"
  "docs/evidence/screenshots/v1.1-sentinellite/04-synthetic-demo.png"
  "docs/evidence/screenshots/v1.1-sentinellite/05-json-report-review.png"
  "docs/evidence/screenshots/v1.1-sentinellite/06-static-dashboard-terminal.png"
  "docs/evidence/screenshots/v1.1-sentinellite/07-static-dashboard-browser-summary.png"
  "docs/evidence/screenshots/v1.1-sentinellite/08-static-dashboard-browser-alerts.png"
)
for screenshot in "${screenshots[@]}"; do
  check_required_file "$screenshot"
done

echo
echo "File-presence summary"
echo "Passed:  $pass_count"
echo "Warnings: $warn_count"
echo "Failed:  $fail_count"

echo
echo "Historical screenshot integrity"
integrity_passed=0
integrity_failed=0
check_screenshot_integrity || integrity_failed=1
echo "SHA-256 verified: $integrity_passed/$integrity_expected"

if [[ "$fail_count" -gt 0 || "$integrity_failed" -ne 0 ]]; then
  echo
  echo "ARM-SecNet documentation and evidence validation failed."
  exit 1
fi

echo
echo "ARM-SecNet documentation and evidence validation passed."
