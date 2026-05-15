#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/board.env"

if [ $# -lt 1 ]; then
  echo "Usage: $0 path/to/image.png"
  exit 1
fi

PNG_LOCAL="$1"

if [ ! -f "$PNG_LOCAL" ]; then
  echo "File not found: $PNG_LOCAL"
  exit 1
fi

case "$PNG_LOCAL" in
  *.png|*.PNG)
    ;;
  *)
    echo "File must be a .png"
    exit 1
    ;;
esac

REMOTE_PNG="/tmp_display.png"

echo "Copying PNG to board: $PNG_LOCAL -> :$REMOTE_PNG"
${MPREMOTE} fs cp "$PNG_LOCAL" ":$REMOTE_PNG"

TMP_SCRIPT="$(mktemp)"
trap 'rm -f "$TMP_SCRIPT"' EXIT

cat > "$TMP_SCRIPT" <<PY
import time
import os
from pngdec import PNG
from core.display import DisplayManager

REMOTE_PNG = "$REMOTE_PNG"

dm = DisplayManager()
display = dm.display

dm.clear()

png = PNG(display)
png.open_file(REMOTE_PNG)
png.decode(0, 0)

dm.update()

try:
    os.remove(REMOTE_PNG)
except OSError:
    pass
PY

echo "Displaying PNG..."
${MPREMOTE} run "$TMP_SCRIPT"