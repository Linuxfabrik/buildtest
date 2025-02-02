#!/usr/bin/env bash

set -e

PLUGIN_DIR=$1
PLUGIN_NAMES=$2
OUTPUT_COMPILED_DIR=$3
OUTPUT_PACKAGE_DIR=$4

# The first parameter (if any) is a comma-separated list of plugin names.

# If PLUGIN_NAMES is empty, find all plugin directories under $PLUGIN_DIR/ and create a comma-separated list.
if [[ -z "$PLUGIN_NAMES" ]]; then
    echo "No plugin list provided. Discovering all plugins..."
    # Find directories immediately under $PLUGIN_DIR/, extract their basenames, and join them with commas.
    PLUGIN_NAMES=$(find $PLUGIN_DIR -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | paste -sd "," -)
fi

# Split the comma-separated list into an array.
IFS=',' read -r -a plugins <<< "$INPUT_PLUGINS"

# Loop through each plugin in the list.
mkdir -p $OUTPUT_COMPILE_DIR
for plugin in "${plugins[@]}"; do
    # Trim any accidental whitespace.
    plugin=$(echo "$plugin" | xargs)
    if [ "$plugin" == "example" ]; then
        continue
    fi
    echo "Processing plugin: $plugin"
    if [[ -d "$PLUGIN_DIR/$plugin" ]]; then
        ./compile-using-nuitka "$PLUGIN_DIR/$plugin" "$plugin" "$OUTPUT_COMPILED_DIR"
    else
        echo "Directory $PLUGIN_DIR/$plugin does not exist. Skipping."
        exit 1
    fi
done

mkdir -p $OUTPUT_PACKAGE_DIR
\cp --archive --no-clobber $OUTPUT_COMPILED_DIR/*.dist/* $OUTPUT_PACKAGE_DIR

exit 1