#!/usr/bin/env bash
dir=${1:?usage: bash export.sh <dir-of-ase-files>}
aseprite=${ASEPRITE:-$(zsh -ic 'whence -p aseprite' 2>/dev/null)}
[ -n "$aseprite" ] || { echo "could not resolve aseprite binary" >&2; exit 1; }
for f in "$dir"/*.ase*; do
  [ -e "${f%.*}.jpg" ] && continue
  "$aseprite" -b "$f" --scale 5 --save-as "${f%.*}.png"
  dims=$(magick "${f%.*}.png" -format '%wx%h' info:)
  magick -size $dims pattern:checkerboard "${f%.*}.png" -compose over -composite "${f%.*}.jpg"
  rm "${f%.*}.png"
done

echo ok
