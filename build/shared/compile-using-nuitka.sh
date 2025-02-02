#!/usr/bin/env bash

set -e

SCRIPT_DIR=$1
SCRIPT_NAME=$2
OUTPUT_DIR=$3

echo -e "\nCompiling $SCRIPT_NAME..."
python -m nuitka \
    --assume-yes-for-downloads \
    --output-dir=$OUTPUT_DIR/ \
    --remove-output \
    --standalone \
    "$SCRIPT_DIR/$SCRIPT_NAME"
mv "$OUTPUT_DIR/$SCRIPT_NAME.dist/$SCRIPT_NAME.bin" "$OUTPUT_DIR/$SCRIPT_NAME.dist/$SCRIPT_NAME"
