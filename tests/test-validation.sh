#!/bin/bash

set -e

echo "Running automated tests..."

# Test 1: Validation script must exist
if [ ! -f "scripts/validate-project.sh" ]; then
    echo "FAIL: Validation script is missing"
    exit 1
fi

echo "PASS: Validation script exists"

# Test 2: Validation script syntax must be valid
bash -n scripts/validate-project.sh
echo "PASS: Validation script syntax is valid"

# Test 3: Validation must fail when README.md is missing
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

mkdir -p "$temp_dir/scripts" "$temp_dir/docs" "$temp_dir/.github/workflows"
cp scripts/validate-project.sh "$temp_dir/scripts/"

touch "$temp_dir/docs/cloudwatch-monitoring.md"
touch "$temp_dir/.github/workflows/git-practice.yml"

if (cd "$temp_dir" && bash scripts/validate-project.sh) >"$temp_dir/output.txt" 2>&1; then
    echo "FAIL: Validation passed even though README.md is missing"
    exit 1
fi

if ! grep -q "ERROR: README.md is missing" "$temp_dir/output.txt"; then
    echo "FAIL: Expected README error message was not found"
    cat "$temp_dir/output.txt"
    exit 1
fi

echo "PASS: Validation rejects a missing README.md"
echo "All automated tests passed!"
