#!/usr/bin/env bash

set -e -x

MONITORING_PLUGINS_DIR="$1"
PACKAGE_VERSION=$2
PACKAGE_ITERATION=$3
PACKAGE_ARCH=$3

mkdir -p /tmp/fpm/np
cd /tmp/fpm/np || exit 1

cat << EOF > .fpm
--architecture "$PACKAGE_ARCH"
--chdir /tmp/output/summary/notification-plugins
--description "Notification scripts for Icinga."
--input-type dir
--iteration "$PACKAGE_ITERATION"
--license "The Unlicense"
--maintainer "info@linuxfabrik.ch"
--name linuxfabrik-notification-plugins
--rpm-summary "The Linuxfabrik Monitoring Plugins Collection (Notification Plugins)"
--url "https://github.com/Linuxfabrik/monitoring-plugins"
--vendor "Linuxfabrik GmbH, Zurich, Switzerland"
--version "$PACKAGE_VERSION"
EOF

# build the notification-plugins file list
cd /tmp/output/summary/notification-plugins || exit 1
find . -type f -print0 | while IFS= read -r -d '' file; do
    file=${file#./}
    file=${file// /\\ }
    echo "$file=/usr/lib64/nagios/plugins/$file" >> /tmp/fpm/np/.fpm
done
}
