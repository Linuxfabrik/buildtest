#!/usr/bin/env bash
# 2025021001

# This runs in a container.

set -e -x

if [[ ! -d "$LFMP_DIR_REPOS/lib" ]]; then
    echo "The Python libraries (https://github.com/Linuxfabrik/lib) could not be found at $LFMP_DIR_REPOS/lib."
    echo "They should be in a directory called 'lib' on the same level as the monitoring-plugins directory."
    exit 2
fi

source /opt/venv/bin/activate
python3 --version
python3 -m pip install --requirement="$LFMP_DIR_REPOS/$LFMP_REPO_MP/requirements.txt" --require-hashes

# If $LFMP_COMPILE_PLUGINS is empty, find all plugin directories under
# $LFMP_DIR_REPOS/$LFMP_REPO_MP/$PLUGINS/ and create a comma-separated list.
if [[ -z "$LFMP_COMPILE_PLUGINS" ]]; then
    echo "No plugin list provided. Discovering all plugins..."
    # Find directories immediately under $PLUGINS/, extract their basenames, and join them with commas.
    LFMP_COMPILE_PLUGINS=$(find "$LFMP_DIR_REPOS/$LFMP_REPO_MP/$PLUGINS" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)
fi

# Loop through each plugin in the list.
for PLUGINS in check-plugins notification-plugins event-plugins; do
    echo "Processing $PLUGINS..."
    for PLUGIN in $LFMP_COMPILE_PLUGINS; do
        if [ "$PLUGIN" == "example" ]; then
            continue
        fi
        echo "Processing $PLUGIN"
        if [[ -d "$LFMP_DIR_REPOS/$LFMP_REPO_MP/$PLUGINS/$PLUGIN" ]]; then
            echo $(pwd)
            bash $(dirname "$0")/compile-one.sh $PLUGINS $PLUGIN
        else
            echo "Directory $LFMP_DIR_REPOS/$PLUGINS/$PLUGIN does not exist. Ignoring..."
        fi
    done
done
