#!/bin/bash
url="https://pokemmo.com/download_file/1/"

# Get the redirect URL from HTTP headers
redirectUrl=$(curl -s -I "$url" | grep -i "Location:" | tail -1 | sed 's/Location: //I' | tr -d '\r')
if [[ -z "$redirectUrl" ]]; then
    echo "No redirect URL found."
    exit 1
fi

# Extract revision number after 'r='
revision=$(echo "$redirectUrl" | sed -n 's/.*r=\([0-9]*\).*/\1/p')
if [[ -z "$revision" ]]; then
    echo "Revision number not found in URL."
    exit 1
fi

# Ensure the revisions folder exists
revisionsFolder="revisions"
mkdir -p "$revisionsFolder"

outputFile="${revisionsFolder}/${revision}.zip"

# Check if the file already exists - skip download if so
if [[ -f "$outputFile" ]]; then
    echo "Revision $revision already exists. Skipping download."
    exit 0
fi

echo "Downloading revision $revision..."
curl -L "$redirectUrl" -o "$outputFile"
echo "Download complete for revision $revision."
