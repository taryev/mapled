#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source tools/board.env


${MPREMOTE} soft-reset repl