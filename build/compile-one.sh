#!/usr/bin/env bash
# 2025021104

# This runs in a container.

set -e -x

if uname -a | grep -q "_NT"; then
    # We are on Windows.
    REPO_DIR="$LFMP_DIR_REPOS"
    COMPILE_DIR="$LFMP_DIR_COMPILED"
else
    # We are in a container.
    REPO_DIR="/repos"
    COMPILE_DIR="/compiled"
fi

# inputs:
PLUGINS=$1  # what to compile - "check-plugins", "notification-plugins" or "event-plugins"
PLUGIN=$2   # which plugin to compile, for example "cpu-usage"

if uname -a | grep -q "_NT"; then
    # We are on Windows.
    if [ ! -f "$REPO_DIR/monitoring-plugins/$PLUGINS/$PLUGIN/.windows" ]; then
        echo "✅ Ignoring '$PLUGIN' on Windows"
        exit 0
    fi
    ADDITIONAL_PARAMS="--include-plugin-directory=$REPO_DIR/lib --msvc=latest"
fi


echo "✅ Compiling $PLUGIN..."

if ! uname -a | grep -q "_NT"; then
    source /opt/venv/bin/activate
fi
python3 -m nuitka \
    --assume-yes-for-downloads \
    --output-dir=$COMPILE_DIR/$PLUGINS/ \
    --remove-output \
    --standalone \
    $ADDITIONAL_PARAMS \
    $REPO_DIR/monitoring-plugins/$PLUGINS/$PLUGIN/$PLUGIN

if [ -e "$COMPILE_DIR/$PLUGINS/$PLUGIN.dist/$PLUGIN.bin" ]; then
    # On Linux, compiled files get the ".bin" extension.
    # On Windows, compiled files automatically get the ".exe" extension.
    mv "$COMPILE_DIR/$PLUGINS/$PLUGIN.dist/$PLUGIN.bin" "$COMPILE_DIR/$PLUGINS/$PLUGIN.dist/$PLUGIN"
fi
