#!/usr/bin/env bash

set -e

SCRIPT_DIR=$1
SCRIPT_NAME=$2
OUTPUT_DIR=$3

# The first parameter (if any) is a comma-separated list of plugin names.
INPUT_PLUGINS="$1"

# If INPUT_PLUGINS is empty, find all plugin directories under $SCRIPT_DIR/ and create a comma-separated list.
if [[ -z "$INPUT_PLUGINS" ]]; then
  echo "No plugin list provided. Discovering all plugins..."
  # Find directories immediately under $SCRIPT_DIR/, extract their basenames, and join them with commas.
  INPUT_PLUGINS=$(find $SCRIPT_DIR -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | paste -sd "," -)
fi

mkdir -p $RUNNER_TEMP/package-me/{check,notification}-plugins
\cp --archive --no-clobber $RUNNER_TEMP/compiled/check-plugins/*.dist/* $RUNNER_TEMP/package-me/check-plugins

exit 1