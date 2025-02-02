#!/usr/bin/env bash

set -e -x

PLUGIN_DIR=$1
PLUGIN_NAME=$2
OUTPUT_DIR=$3

echo -e "\nCompiling $PLUGIN_NAME..."
PLUGIN="$PLUGIN_NAME/$PLUGIN_NAME"
python -m nuitka \
    --assume-yes-for-downloads \
    --output-dir=$OUTPUT_DIR/ \
    --remove-output \
    --standalone \
    "$PLUGIN_DIR/$PLUGIN"
if [[ -e "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" ]]; then
    # On Linux, files have the ".bin" extension.
    # On Windows, files are already named ".exe".
    mv "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME"
fi
