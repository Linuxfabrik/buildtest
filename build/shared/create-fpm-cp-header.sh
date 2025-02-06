#!/usr/bin/env bash

set -e -x

MONITORING_PLUGINS_DIR="$1"
DIST_DIR=$2
PACKAGE_VERSION=$3
PACKAGE_ITERATION=$4
PACKAGE_ARCH=$5

mkdir -p /tmp/fpm/cp

cat > /tmp/fpm/cp/.fpm <<EOF
--after-install "$MONITORING_PLUGINS_DIR/build/shared/rpm-post-install.sh"
--architecture "$PACKAGE_ARCH"
--chdir "$DIST_DIR/check-plugins"
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
