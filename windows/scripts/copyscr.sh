#!/usr/bin/env bash
set -euo pipefail

name="$1"
destination="$2"
screenshots_dir="/c/Users/lucas.mclaughlin.sca/Pictures/Screenshots"

latest=$(find "$screenshots_dir" -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.bmp" -o -iname "*.gif" -o -iname "*.webp" \) \
    -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)

if [[ ! -d "$destination" ]]; then
    echo "Error: destination directory '$destination' does not exist" >&2
    exit 1
fi

if [[ -z "$latest" ]]; then
    echo "Error: no images found in $screenshots_dir" >&2
    exit 1
fi

ext="${latest##*.}"
dest="$destination/$name.$ext"

cp "$latest" "$dest"
echo "Copied '$(basename "$latest")' -> '$dest'"
