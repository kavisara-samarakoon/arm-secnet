#!/usr/bin/env bash

set -euo pipefail

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

check_optional_file() {
  local file_path="$1"

  if [[ -s "$file_path" ]]; then
    echo "[PASS] $file_path exists and is not empty"
    pass_count=$((pass_count + 1))
  else
    echo "[WARN] $file_path is not ready yet"
    warn_count=$((warn_count + 1))
  fi
}

echo "ARM-SecNet Validation Check"
echo "==========================="
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

echo
echo "Screenshot files:"
echo

check_required_file "docs/evidence/screenshots/01-arm64-hostnamectl.png"
check_required_file "docs/evidence/screenshots/02-network-shared-nat.png"
check_required_file "docs/evidence/screenshots/03-lab01-system-baseline.png"
check_required_file "docs/evidence/screenshots/04-lab01-users-processes.png"
check_required_file "docs/evidence/screenshots/05-auth-log-sudo-activity.png"

echo
echo "Summary"
echo "======="
echo "Passed:  $pass_count"
echo "Warnings: $warn_count"
echo "Failed:  $fail_count"

if [[ "$fail_count" -gt 0 ]]; then
  echo
  echo "Validation failed. Fix required files before committing."
  exit 1
fi

echo
echo "ARM-SecNet V1 validation passed."