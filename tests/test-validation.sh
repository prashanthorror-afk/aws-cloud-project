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

# Prepare an isolated test environment
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

mkdir -p "$temp_dir/scripts" "$temp_dir/docs" "$temp_dir/.github/workflows"
cp scripts/validate-project.sh "$temp_dir/scripts/"

# Test 3: Missing README must be rejected
touch "$temp_dir/docs/cloudwatch-monitoring.md"
touch "$temp_dir/.github/workflows/git-practice.yml"

if (cd "$temp_dir" && bash scripts/validate-project.sh) >"$temp_dir/output.txt" 2>&1; then
    echo "FAIL: Missing README was accepted"
    exit 1
fi

grep -q "ERROR: README.md is missing" "$temp_dir/output.txt"
echo "PASS: Missing README is rejected"

# Test 4: Missing CloudWatch documentation must be rejected
touch "$temp_dir/README.md"
rm "$temp_dir/docs/cloudwatch-monitoring.md"

if (cd "$temp_dir" && bash scripts/validate-project.sh) >"$temp_dir/output.txt" 2>&1; then
    echo "FAIL: Missing CloudWatch documentation was accepted"
    exit 1
fi

grep -q "ERROR: CloudWatch documentation is missing" "$temp_dir/output.txt"
echo "PASS: Missing CloudWatch documentation is rejected"

# Test 5: Missing workflow must be rejected
touch "$temp_dir/docs/cloudwatch-monitoring.md"
rm "$temp_dir/.github/workflows/git-practice.yml"

if (cd "$temp_dir" && bash scripts/validate-project.sh) >"$temp_dir/output.txt" 2>&1; then
    echo "FAIL: Missing workflow was accepted"
    exit 1
fi

grep -q "ERROR: GitHub Actions workflow is missing" "$temp_dir/output.txt"
echo "PASS: Missing workflow is rejected"

# Test 6: All required files present must pass
touch "$temp_dir/.github/workflows/git-practice.yml"

(
    cd "$temp_dir"
    bash scripts/validate-project.sh
) >"$temp_dir/output.txt" 2>&1

grep -q "SUCCESS: Required project files exist." "$temp_dir/output.txt"
echo "PASS: Validation succeeds when all required files exist"

echo "All automated tests passed!"
