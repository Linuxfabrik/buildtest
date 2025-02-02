#!/usr/bin/env python3
import os
import sys
import json
import requests
import zipfile
from io import BytesIO


REPO = sys.argv[1]
GITHUB_TOKEN = sys.argv[2]

GH_API_URL = f"https://api.github.com/repos/{REPO}/actions/artifacts"
ARTIFACT_NAME = "version"
headers = {
    "Authorization": f"Bearer {GITHUB_TOKEN}",
    "Accept": "application/vnd.github.v3+json",
}

# Fetch all artifacts from the GitHub API
response = requests.get(GH_API_URL, headers=headers)
if response.status_code != 200:
    print(f"❌ Failed to fetch artifacts. HTTP {response.status_code}: {response.text}")
    sys.exit(1)

data = response.json()

# Filter artifacts by name and sort by created_at (oldest first)
artifacts = data.get("artifacts", [])
matching_artifacts = [a for a in artifacts if a.get("name") == ARTIFACT_NAME]
if matching_artifacts:
    # sort by created_at and pick the latest artifact
    matching_artifacts.sort(key=lambda x: x.get("created_at"))
    artifact_info = matching_artifacts[-1]
else:
    artifact_info = {}

# Extract the download URL from the artifact info
artifact_url = artifact_info.get("archive_download_url", "").strip()

if not artifact_url:
    print("❌ No previous version artifact found. Exiting...")
    sys.exit(1)
else:
    print(f"✅ Downloading artifact from: {artifact_url}")
    # Download the artifact archive (ZIP)
    download_response = requests.get(artifact_url, headers={"Authorization": f"Bearer {GITHUB_TOKEN}"}, stream=True)
    if download_response.status_code != 200:
        print(f"❌ Failed to download artifact. HTTP {download_response.status_code}")
        sys.exit(1)

    # Write the ZIP file to disk
    zip_filename = os.path.join(
        os.environ.get('RUNNER_TEMP'),
        "version.zip",
    )
    with open(zip_filename, "wb") as f:
        f.write(download_response.content)

    # Create extraction directory
    extract_dir = os.path.join(
        os.environ.get('RUNNER_TEMP')
        "version_artifact",
    )
    os.makedirs(extract_dir, exist_ok=True)

    # Extract the ZIP file
    with zipfile.ZipFile(zip_filename, "r") as zip_ref:
        zip_ref.extractall(extract_dir)

    # Read the version from the extracted file
    version_file_path = os.path.join(
        extract_dir,
        "version.txt",
    )
    if not os.path.isfile(version_file_path):
        print(f"❌ Could not find version file at {version_file_path}")
        sys.exit(1)
    with open(version_file_path, "r") as vf:
        version = vf.read().strip()

    print(f"✅ Extracted version: {version}")

    # Append an environment variable for later steps if GITHUB_ENV is set.
    github_env = os.environ.get("GITHUB_ENV")
    if github_env:
        try:
            with open(github_env, "a") as env_file:
                env_file.write(f"VERSION={version}\n")
            print(f"✅ Appended VERSION={version} to {github_env}")
        except Exception as e:
            print(f"❌ Failed to write to GITHUB_ENV file: {e}")
    else:
        print("ℹ️ GITHUB_ENV not set; skipping appending the environment variable.")
