#!/usr/bin/env bash

set -e -x

TODO

# RHEL only - compile .te file to .pp for SELinux
mkdir /tmp/selinux
cp /repos/monitoring-plugins/assets/selinux/linuxfabrik-monitoring-plugins.te /tmp/selinux/
cd /tmp/selinux/
make --file /usr/share/selinux/devel/Makefile linuxfabrik-monitoring-plugins.pp
\cp -a linuxfabrik-monitoring-plugins.pp /tmp/output/summary/check-plugins
