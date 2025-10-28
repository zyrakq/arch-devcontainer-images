#!/bin/bash
# Script to list all available images from metadata.json files
# Used by push-to-custom-registry workflow

set -euo pipefail

# Find all metadata.json files and extract image names
find src -name "metadata.json" -type f | while read -r metadata; do
    name=$(jq -r '.name' "$metadata")
    echo "$name"
done | sort -u