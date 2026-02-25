#!/bin/bash
# screenshot.sh - Take a screenshot of a webpage
# Usage: screenshot.sh <url> [output_path]

URL="${1:-}"
OUTPUT="${2:-screenshot.png}"

if [ -z "$URL" ]; then
    echo "Error: No URL provided"
    echo "Usage: screenshot.sh <url> [output_path]"
    exit 1
fi

npx playwright screenshot --wait-for-timeout 3000 "$URL" "$OUTPUT"
echo "Screenshot saved to: $OUTPUT"
