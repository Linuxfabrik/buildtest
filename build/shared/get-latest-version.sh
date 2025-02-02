#!/usr/bin/env bash

set -e

REPO=$1
GITHUB_TOKEN=$2

GH_API_URL="https://api.github.com/repos/$REPO/actions/artifacts"
ARTIFACT_NAME="version"

echo "Fetching latest version.txt..."

# Fetch all artifacts and filter by name
ARTIFACT_INFO=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" "$GH_API_URL" | \
    jq -r ".artifacts | map(select(.name == \"$ARTIFACT_NAME\")) | sort_by(.created_at) | last // {}")

# Extract the download URL
ARTIFACT_URL=$(echo "$ARTIFACT_INFO" | jq -r ".archive_download_url // empty")

if [[ -z "$ARTIFACT_URL" ]]; then
    echo "❌ No previous version artifact found. Exiting..."
    exit 1
else
    echo "✅ Downloading artifact from: $ARTIFACT_URL"
    curl -L -o version.zip -H "Authorization: Bearer $GITHUB_TOKEN" "$ARTIFACT_URL"
    mkdir -p version_artifact
    unzip -o version.zip -d version_artifact
    VERSION=$(cat version_artifact/version.txt)
    echo "✅ Extracted version: $VERSION"
    # Append an environment variable for later steps
    echo "VERSION=$VERSION" >> $GITHUB_ENV
fi
