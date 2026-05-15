#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="./src"
OUT_DIR="./png"

mkdir -p "$OUT_DIR"

if ! command -v aseprite >/dev/null 2>&1; then
  echo "Error: aseprite is not in PATH"
  exit 1
fi

find "$SRC_DIR" -type f -name "*.aseprite" | while read -r file; do
  base_name="$(basename "$file" .aseprite)"
  out_file="$OUT_DIR/$base_name.png"

  echo "Export: $file -> $out_file"

  aseprite \
    --batch "$file" \
    --save-as "$out_file"
done

echo "Done."