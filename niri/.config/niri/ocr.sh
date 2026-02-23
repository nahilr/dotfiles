#!/usr/bin/env bash
set -euo pipefail
# Use provided SLURP_ARGS if set
slurp_args="${SLURP_ARGS:-}"
# Capture selection geometry from slurp; exit if nothing selected
sel="$(slurp $slurp_args)"
[ -n "$sel" ] || exit 0
out="/tmp/ocr_image.png"
# Take screenshot of the selected area
grim -g "$sel" "$out"
# Build tesseract language list (skip the header), join with +
langs="$(tesseract --list-langs | awk 'NR>1{printf sep $1; sep="+"} END{print ""}')"
# Run OCR and copy to clipboard
tesseract "$out" stdout -l "$langs" | wl-copy
# Clean up
rm -f "$out"

#grim -g "$(slurp $SLURP_ARGS)" "/tmp/ocr_image.png" && tesseract "/tmp/ocr_image.png" stdout -l $(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\n' '+' | sed 's/\\+$/\\n/') | wl-copy && rm "/tmp/ocr_image.png"