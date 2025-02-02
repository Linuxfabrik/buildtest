#!/usr/bin/env bash

set -e

PLUGIN_DIR=$1
PLUGIN_NAME=$2
OUTPUT_DIR=$3

PLUGIN="$2/$2"

echo -e "\nCompiling $PLUGIN_NAME..."
python -m nuitka \
    --assume-yes-for-downloads \
    --output-dir=$OUTPUT_DIR/ \
    --remove-output \
    --standalone \
    "$PLUGIN_DIR/$PLUGIN"
mv "$OUTPUT_DIR/$PLUGIN.dist/$PLUGIN_NAME.bin" "$OUTPUT_DIR/$PLUGIN.dist/$PLUGIN_NAME"
