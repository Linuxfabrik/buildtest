#!/usr/bin/env bash

set -e -x

MONITORING_PLUGINS_DIR="$1"
PACKAGE_VERSION=$2
PACKAGE_ITERATION=$3
PACKAGE_ARCH=$3

cat <<EOF > "$FPM_FILE"
--after-install "$MONITORING_PLUGINS_DIR/build/shared/rpm-post-install.sh"
--architecture "$PACKAGE_ARCH"
--chdir /tmp/output/summary/check-plugins
--description "This Enterprise Class Check Plugin Collection offers a bunch of Nagios-compatible check plugins for Icinga, Naemon, Nagios, OP5, Shinken, Sensu and other monitoring applications. Each plugin is a stand-alone command line tool that provides a specific type of check. Typically, your monitoring software will run these check plugins to determine the current status of hosts and services on your network."
--input-type dir
--iteration "$PACKAGE_ITERATION"
--license "The Unlicense"
--maintainer "info@linuxfabrik.ch"
--name linuxfabrik-monitoring-plugins
--rpm-summary "The Linuxfabrik Monitoring Plugins Collection (Check Plugins)"
--url "https://github.com/Linuxfabrik/monitoring-plugins"
--vendor "Linuxfabrik GmbH, Zurich, Switzerland"
--version "$PACKAGE_VERSION"
EOF

# prepare and ship the sudoers file
vendor=$(get_vendor)
if [ "$vendor" != "other" ]; then
    \cp --archive "$MONITORING_PLUGINS_DIR"/assets/sudoers/"$vendor".sudoers /tmp/output/summary/check-plugins/_sudoers
else
    true > /tmp/output/summary/check-plugins/_sudoers
fi
echo "_sudoers=/etc/sudoers.d/monitoring-plugins" >> /tmp/fpm/check-plugins/.fpm

# prepare and ship the asset files for all check-plugins
mkdir -p /tmp/output/summary/check-plugins/assets/
cd /tmp/output/summary/check-plugins || exit 1
find "$MONITORING_PLUGINS_DIR"/check-plugins -type d -name 'assets' -exec find {} -type f -print0 \; | while IFS= read -r -d '' file; do
    \cp --archive "$file" /tmp/output/summary/check-plugins/assets/
    file=$(basename "$file")
    echo "assets/$file=/usr/lib64/nagios/plugins/assets/$file" >> /tmp/fpm/check-plugins/.fpm
done

echo $(cat "$FPM_FILE")
