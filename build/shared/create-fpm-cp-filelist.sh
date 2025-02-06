#!/usr/bin/env bash

set -e -x

MONITORING_PLUGINS_DIR="$1"
DIST_DIR=$2
PACKAGE_VERSION=$3
PACKAGE_ITERATION=$4
PACKAGE_ARCH=$5
TARGET_OS_FAMILY=$6  # "RedHat", "Debian" or "other"

# build the check-plugins file list
cd $DIST_DIR/|| exit 1
find . -type f -print0 | while IFS= read -r -d '' file; do
    file=${file#./}      # remove leading './'
    file=${file// /\\ }  # handle file names with spaces correctly, escape all spaces
    echo "$file=/usr/lib64/nagios/plugins/$file" >> /tmp/fpm/cp/.fpm
done

# prepare and ship the sudoers file
cd
if [ "$TARGET_OS_FAMILY" != "other" ]; then
    \cp --archive "$MONITORING_PLUGINS_DIR"/assets/sudoers/"$TARGET_OS_FAMILY".sudoers $DIST_DIR/_sudoers
    echo "_sudoers=/etc/sudoers.d/monitoring-plugins" >> /tmp/fpm/cp/.fpm
fi

# prepare and ship the asset files for all check-plugins
mkdir -p $DIST_DIR/assets/
cd $DIST_DIR/|| exit 1
find "$MONITORING_PLUGINS_DIR"/check-plugins -type d -name 'assets' -exec find {} -type f -print0 \; | while IFS= read -r -d '' file; do
    \cp --archive "$file" $DIST_DIR/assets/
    file=$(basename "$file")
    echo "assets/$file=/usr/lib64/nagios/plugins/assets/$file" >> /tmp/fpm/cp/.fpm
done

echo $(cat "$FPM_FILE")
