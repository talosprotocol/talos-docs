#!/usr/bin/env bash
set -euo pipefail

echo "Validating documentation..."
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Check for core documentation files
if [[ ! -f "$ROOT_DIR/docs/STANDARDIZATION_PLAN.md" ]]; then
    echo "✖  Missing core documentation: STANDARDIZATION_PLAN.md"
    exit 1
fi

echo "Documentation validation passed."
exit 0
