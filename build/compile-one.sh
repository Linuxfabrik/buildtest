#!/usr/bin/env bash
# 2025021001

set -e -x

# inputs:
PLUGINS=$1  # what to compile - "check-plugins", "notification-plugins" or "event-plugins"
PLUGIN=$2   # which plugin to compile, for example "cpu-usage"

if uname -a | grep -q "_NT"; then
    # We are on Windows.
    if [ ! -f "$LFMP_DIR_REPOS/$LFMP_REPO_MP/$PLUGINS/$PLUGIN/.windows" ]; then
        echo "Ignoring '$PLUGIN'"
        exit 0
    fi
    ADDITIONAL_PARAMS="--include-plugin-directory=$LFMP_DIR_REPOS/lib --msvc=latest"
fi


echo "Compiling $PLUGIN..."

source /opt/venv/bin/activate
python3 -m nuitka \
    --assume-yes-for-downloads \
    --output-dir="$LFMP_DIR_COMPILED"/$PLUGINS/ \
    --remove-output \
    --standalone \
    $ADDITIONAL_PARAMS \
    $LFMP_DIR_REPOS/$LFMP_REPO_MP/$PLUGINS/$PLUGIN/$PLUGIN

if [ -e "$LFMP_DIR_COMPILED/$PLUGINS/$PLUGIN.dist/$PLUGIN.bin" ]; then
    # On Linux, compiled files have the ".bin" extension.
    # On Windows, compiled files have an ".exe" extension.
    mv "$LFMP_DIR_COMPILED/$PLUGINS/$PLUGIN.dist/$PLUGIN.bin" "$LFMP_DIR_COMPILED/$PLUGINS/$PLUGIN.dist/$PLUGIN"
fi
