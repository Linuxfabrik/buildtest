#!/usr/bin/env bash

set -e -x

LIB_DIR=$1
PLUGIN_DIR=$2
PLUGIN_NAME=$3
OUTPUT_DIR=$4

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

PYTHON=python
if ! command -v $PYTHON 2>&1 >/dev/null; then
    PYTHON=/opt/venv/bin/python
fi

echo "Compiling $PLUGIN_NAME using $PYTHON"
PLUGIN="$PLUGIN_NAME/$PLUGIN_NAME"
$PYTHON -m nuitka \
    --assume-yes-for-downloads \
    --include-plugin-directory="$LIB_DIR" \
    --output-dir="$OUTPUT_DIR"/ \
    --standalone \
    $ADDITIONAL_PARAMS \
    "$PLUGIN_DIR/$PLUGIN"
#     --remove-output \

if [ -e "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" ]; then
    # On Linux, compiled files have the ".bin" extension.
    # On Windows, compiled files have an ".exe" extension.
    mv "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME.bin" "$OUTPUT_DIR/$PLUGIN_NAME.dist/$PLUGIN_NAME"
fi
