#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/board.env"

if [ $# -lt 1 ]; then
  echo "Usage: $0 path/to/script.py"
  exit 1
fi

SCRIPT="$1"

${MPREMOTE} run "$SCRIPT"