#!/bin/bash

# Script to list all image paths for GitHub Actions matrix
# Usage: ./scripts/list-images.sh

set -e

# Find all directories containing metadata.json
find src -name "metadata.json" -type f | while read -r metadata; do
    # Get the directory path relative to src/
    dir=$(dirname "$metadata")
    # Extract the image path (remove src/ prefix)
    image_path="${dir#src/}"
    echo "$image_path"
done | sort