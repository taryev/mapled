#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source tools/board.env

read -rp "WARNING This will wipe ALL files on the board. Continue? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

echo "Wiping all files on board..."
${MPREMOTE} exec "
import os

def rmrf(path):
    try:
        entries = os.listdir(path)
    except OSError:
        os.remove(path)
        return
    for entry in entries:
        full = path + '/' + entry if path != '/' else '/' + entry
        try:
            os.listdir(full)
            rmrf(full)
            os.rmdir(full)
        except OSError:
            os.remove(full)

for entry in os.listdir('/'):
    full = '/' + entry
    try:
        os.listdir(full)
        rmrf(full)
        os.rmdir(full)
    except OSError:
        os.remove(full)

print('Done.')
"

echo "Hard reset..."
${MPREMOTE} reset || true
echo "Done."