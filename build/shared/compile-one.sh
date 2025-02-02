#!/usr/bin/env bash

set -e -x

PLUGIN_DIR=$1
PLUGIN_NAME=$2
OUTPUT_DIR=$3

if [ "$PLUGIN_NAME" == "example" ]; then
    echo "Ignoring 'example' plugin"
    exit 0
fi

echo "Compiling $PLUGIN_NAME..."
PLUGIN="$PLUGIN_NAME/$PLUGIN_NAME"

if uname -a | grep -q "_NT"; then
    # We are on Windows.
    python -m nuitka \
        --assume-yes-for-downloads \
        --output-dir=$OUTPUT_DIR/ \
        --remove-output \
        --standalone \
        --msvc=latest \
        "$PLUGIN_DIR/$PLUGIN"
else
    python -m nuitka \
        --assume-yes-for-downloads \
        --output-dir=$OUTPUT_DIR/ \
        --remove-output \
        --standalone \
        "$PLUGIN_DIR/$PLUGIN"
fi

if [[ -e "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" ]]; then
    # On Linux, files have the ".bin" extension.
    # On Windows, files are already named ".exe".
    mv "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME"
fi
