#!/usr/bin/env bash
# 2025021103

# This runs in a container.

set -e -x

# inputs:
PLUGINS=$1  # what to compile - "check-plugins", "notification-plugins" or "event-plugins"
PLUGIN=$2   # which plugin to compile, for example "cpu-usage"

if uname -a | grep -q "_NT"; then
    # We are on Windows.
    if [ ! -f "/repos/monitoring-plugins/$PLUGINS/$PLUGIN/.windows" ]; then
        echo "✅ Ignoring '$PLUGIN' on Windows"
        exit 0
    fi
    ADDITIONAL_PARAMS="--include-plugin-directory=/repos/lib --msvc=latest"
fi


echo "✅ Compiling $PLUGIN..."

source /opt/venv/bin/activate
python3 -m nuitka \
    --assume-yes-for-downloads \
    --output-dir=/compiled/$PLUGINS/ \
    --remove-output \
    --standalone \
    $ADDITIONAL_PARAMS \
    /repos/monitoring-plugins/$PLUGINS/$PLUGIN/$PLUGIN

if [ -e "/compiled/$PLUGINS/$PLUGIN.dist/$PLUGIN.bin" ]; then
    # On Linux, compiled files have the ".bin" extension.
    # On Windows, compiled files have an ".exe" extension.
    mv "/compiled/$PLUGINS/$PLUGIN.dist/$PLUGIN.bin" "/compiled/$PLUGINS/$PLUGIN.dist/$PLUGIN"
fi
