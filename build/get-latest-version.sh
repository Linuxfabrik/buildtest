#!/usr/bin/env bash
# 2025021001

set -e

GITHUB_API_URL="https://api.github.com/repos/$GITHUB_REPOSITORY/actions/artifacts"
ARTIFACT_NAME="version"

sudo apt update
sudo apt -y install jq


echo "Fetching all artifacts via REST and filter by name to get the latest version"
ARTIFACT_INFO=$(curl --silent \
    --header "Authorization: Bearer $GITHUB_TOKEN" \
    --header "Accept: application/vnd.github.v3+json" \
    "$GITHUB_API_URL" | \
    jq --raw-output ".artifacts | map(select(.name == \"$ARTIFACT_NAME\")) | sort_by(.created_at) | last // {}")

# Extract the download URL
ARTIFACT_URL=$(echo "$ARTIFACT_INFO" | jq --raw-output ".archive_download_url // empty")

if [[ -z "$ARTIFACT_URL" ]]; then
    echo "❌ No previous version artifact found. Exiting..."
    exit 1
else
    echo "✅ Downloading artifact from: $ARTIFACT_URL"
    curl --header "Authorization: Bearer $GITHUB_TOKEN" \
        --location \
        --output version.zip \
        "$ARTIFACT_URL"
    unzip -o version.zip
    LFMP_VERSION=$(cat version.txt)
    rm -f version.txt version.zip
    echo "✅ Extracted version: $LFMP_VERSION"
    # Append an environment variable for later steps
    if [[ -z $GITHUB_ENV ]]; then
        # we are not on an GitHub runner
        export LFMP_VERSION=$LFMP_VERSION
    else
        echo "LFMP_VERSION=$LFMP_VERSION" >> "$GITHUB_ENV"
    fi
fi
