#!/usr/bin/env bash

set -e -x

PLUGIN_DIR=$1
PLUGIN_NAME=$2
OUTPUT_DIR=$3

if [ "$PLUGIN_NAME" == "example" ]; then
    echo "Ignoring '$PLUGIN_NAME'"
    exit 0
fi
if uname -a | grep -q "_NT"; then
    # We are on Windows.
    if [ ! -f "$PLUGIN_DIR/$PLUGIN_NAME/.windows" ]; then
        echo "Ignoring '$PLUGIN_NAME'"
        exit 0
    fi
    ADDITIONAL_PARAMS="--msvc=latest"
fi

echo "Compiling $PLUGIN_NAME..."
PLUGIN="$PLUGIN_NAME/$PLUGIN_NAME"
python -m nuitka \
    --assume-yes-for-downloads \
    --output-dir=$OUTPUT_DIR/ \
    --remove-output \
    --standalone \
    "$ADDITIONAL_PARAMS" \
    "$PLUGIN_DIR/$PLUGIN"

if [ -e "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" ]; then
    # On Linux, compiled files have the ".bin" extension.
    # On Windows, compiled files have an ".exe" extension.
    mv "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME"
fi
