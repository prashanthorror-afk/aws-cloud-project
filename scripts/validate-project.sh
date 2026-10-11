#!/bin/bash

set -e

echo "Starting AWS Cloud Monitoring project validation..."

if [ ! -f "README.md" ]; then
    echo "ERROR: README.md is missing"
    exit 1
fi

if [ ! -f "docs/cloudwatch-monitoring.md" ]; then
    echo "ERROR: CloudWatch documentation is missing"
    exit 1
fi

if [ ! -f ".github/workflows/git-practice.yml" ]; then
    echo "ERROR: GitHub Actions workflow is missing"
    exit 1
fi

echo "SUCCESS: Required project files exist."
