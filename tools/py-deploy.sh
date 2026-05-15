#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source tools/board.env

echo "Deploying src/ to board root..."
${MPREMOTE} cp -r ${BOARD_SRC}/. :/ 

echo "Deploying lib/ to board /lib..."
${MPREMOTE} cp -r ${BOARD_LIB}/. :/lib/

echo "Done."