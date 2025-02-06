#!/usr/bin/env bash

set -e -x

PLUGINS=$1  # check-plugins
PLUGIN=$2   # cpu-usage

# expects env:
# $LFMP_DIR_REPOS
# $LFMP_DIR_DIST

if uname -a | grep -q "_NT"; then
    # We are on Windows.
    if [ ! -f "$LFMP_DIR_REPOS/$PLUGINS/$PLUGIN/.windows" ]; then
        echo "Ignoring '$PLUGIN'"
        exit 0
    fi
    ADDITIONAL_PARAMS="--include-plugin-directory=$LFMP_DIR_REPOS/lib --msvc=latest"
fi


echo "Compiling $PLUGIN using $PYTHON"
PLUGIN="$PLUGIN/$PLUGIN"

source /opt/venv/bin/activate
python3 -m nuitka \
    --assume-yes-for-downloads \
    --output-dir="$LFMP_DIR_DIST"/ \
    --remove-output \
    --standalone \
    $ADDITIONAL_PARAMS \
    $LFMP_DIR_REPOS/$PLUGINS/$PLUGIN/$PLUGIN

if [ -e "$LFMP_DIR_DIST/$PLUGIN.dist/$PLUGIN.bin" ]; then
    # On Linux, compiled files have the ".bin" extension.
    # On Windows, compiled files have an ".exe" extension.
    mv "$LFMP_DIR_DIST/$PLUGIN.dist/$PLUGIN.bin" "$LFMP_DIR_DIST/$PLUGIN.dist/$PLUGIN"
fi
