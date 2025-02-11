#!/usr/bin/env bash
# 2025021001

set -e -x

for LFMP_TARGET_DISTRO in $LFMP_TARGET_DISTROS; do
    for PLUGINS in check-plugins notification-plugins event-plugins; do
        if [[ -d $LFMP_DIR_COMPILED/$LFMP_TARGET_DISTRO/$PLUGINS && -n "$(ls -A $LFMP_DIR_COMPILED/$LFMP_TARGET_DISTRO/$PLUGINS)" ]]; then
            mkdir -p $LFMP_DIR_DIST/$LFMP_TARGET_DISTRO/$PLUGINS
            # directory exists and is not empty
            echo "cp --archive $LFMP_DIR_COMPILED/$LFMP_TARGET_DISTRO/$PLUGINS/*.dist/. $LFMP_DIR_DIST/$LFMP_TARGET_DISTRO/$PLUGINS/"
            \cp --archive $LFMP_DIR_COMPILED/$LFMP_TARGET_DISTRO/$PLUGINS/*.dist/. $LFMP_DIR_DIST/$LFMP_TARGET_DISTRO/$PLUGINS/
        fi
    done
done
