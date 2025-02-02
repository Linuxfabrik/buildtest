#!/usr/bin/env bash

set -e

COMPILE_DIR=$1
PLUGIN_DIR=$2
PLUGIN_NAMES=$3  # a comma-separated list of plugin names (can be empty)

# If PLUGIN_NAMES is empty, find all plugin directories under $PLUGIN_DIR/ and create a comma-separated list.
if [[ -z "$PLUGIN_NAMES" ]]; then
    echo "No plugin list provided. Discovering all plugins..."
    # Find directories immediately under $PLUGIN_DIR/, extract their basenames, and join them with commas.
    PLUGIN_NAMES=$(find $PLUGIN_DIR -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort | paste -sd "," -)
fi

# Split the comma-separated list into an array.
IFS=',' read -r -a plugins <<< "$PLUGIN_NAMES"

# Loop through each plugin in the list.
mkdir -p $COMPILE_DIR
for plugin in "${plugins[@]}"; do
    # Trim any accidental whitespace.
    plugin=$(echo "$plugin" | xargs)
    if [ "$plugin" == "example" ]; then
        continue
    fi
    echo "Processing plugin: $plugin"
    if [[ -d "$PLUGIN_DIR/$plugin" ]]; then
        ./compile-using-nuitka "$PLUGIN_DIR" "$plugin" "$COMPILE_DIR"
    else
        echo "Directory $PLUGIN_DIR/$plugin does not exist. Skipping."
        exit 1
    fi
done

\cp --archive --no-clobber $COMPILE_DIR/*.dist/* $COMPILE_DIR

exit 1