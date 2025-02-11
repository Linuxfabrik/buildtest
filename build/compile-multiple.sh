#!/usr/bin/env bash
# 2025021103

# This runs in a container.

set -e -x

if [[ ! -d "/repos/lib" ]]; then
    echo "❌ The Python libraries (https://github.com/Linuxfabrik/lib) could not be found at /repos/lib."
    echo "❌ They should be in a directory called 'lib' on the same level as the monitoring-plugins directory."
    exit 2
fi

source /opt/venv/bin/activate
python3 --version
python3 -m pip install --requirement="/repos/monitoring-plugins/requirements.txt" --require-hashes

# Loop through each plugin in the list.
for PLUGINS in check-plugins notification-plugins event-plugins; do
    echo "✅ Processing $PLUGINS..."

    # If $LFMP_COMPILE_PLUGINS is empty, find all plugin directories under
    # /repos/monitoring-plugins/$PLUGINS/ and create a space-separated list.
    if [[ -z "$LFMP_COMPILE_PLUGINS" ]]; then
        echo "✅ No plugin list provided. Discovering all plugins..."
        # Find directories immediately under $PLUGINS/, extract their basenames, and join them with commas.
        LFMP_COMPILE_PLUGINS=$(find "/repos/monitoring-plugins/$PLUGINS" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)
        echo "✅ Found $LFMP_COMPILE_PLUGINS"
    fi

    for PLUGIN in $LFMP_COMPILE_PLUGINS; do
        if [ "$PLUGIN" == "example" ]; then
            continue
        fi
        echo "✅ Processing $PLUGIN"
        if [[ -d "/repos/monitoring-plugins/$PLUGINS/$PLUGIN" ]]; then
            echo $(pwd)
            bash $(dirname "$0")/compile-one.sh $PLUGINS $PLUGIN
        else
            echo "✅ Directory /repos/$PLUGINS/$PLUGIN does not exist. Ignoring..."
        fi
    done
    LFMP_COMPILE_PLUGINS=""
done

# On RHEL? Then also compile the Linuxfabrik Type Enforcement Policy
if ! command -v getenforce &> /dev/null; then
    exit 0
fi
mkdir /tmp/selinux
cp /repos/monitoring-plugins/assets/selinux/linuxfabrik-monitoring-plugins.te /tmp/selinux/
cd /tmp/selinux/
make --file /usr/share/selinux/devel/Makefile linuxfabrik-monitoring-plugins.pp
\cp --archive linuxfabrik-monitoring-plugins.pp /compiled/check-plugins/
