#!/usr/bin/env bash

set -e

SCRIPT_DIR=$1
SCRIPT_NAME=$2
OUTPUT_COMPILED_DIR=$3
OUTPUT_PACKAGE_DIR=$4

# The first parameter (if any) is a comma-separated list of plugin names.

# If SCRIPT_NAME is empty, find all plugin directories under $SCRIPT_DIR/ and create a comma-separated list.
if [[ -z "$SCRIPT_NAME" ]]; then
  echo "No plugin list provided. Discovering all plugins..."
  # Find directories immediately under $SCRIPT_DIR/, extract their basenames, and join them with commas.
  SCRIPT_NAME=$(find $SCRIPT_DIR -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | paste -sd "," -)
fi

mkdir -p $OUTPUT_PACKAGE_DIR
\cp --archive --no-clobber $OUTPUT_COMPILED_DIR/*.dist/* $OUTPUT_PACKAGE_DIR

exit 1