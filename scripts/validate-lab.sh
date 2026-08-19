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

check_required_file "README.md"
check_required_file "LICENSE"
check_required_file "CONTRIBUTING.md"
check_required_file "docs/overview.md"
check_required_file "docs/safety.md"
check_required_file "docs/topology.md"

echo
echo "MVP files not required for first foundation commit:"
echo

check_optional_file "docs/setup/macos-utm-setup.md"
check_optional_file "docs/setup/arm64-linux-vm-setup.md"
check_optional_file "docs/labs/lab-01-linux-baseline.md"
check_optional_file "docs/labs/lab-02-auth-log-analysis.md"

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
echo "Foundation validation passed."