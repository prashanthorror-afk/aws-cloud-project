#!/bin/bash

set -e

echo "Running automated tests..."

if [ ! -f "scripts/validate-project.sh" ]; then
    echo "FAIL: Validation script is missing"
    exit 1
fi

bash -n scripts/validate-project.sh

echo "PASS: Validation script exists"
echo "PASS: Validation script syntax is valid"
echo "All automated tests passed!"
