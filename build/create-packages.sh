#!/usr/bin/env bash
# 2025021001

set -e -x

cd
for LFMP_TARGET_DISTRO in $LFMP_TARGET_DISTROS; do
    for PLUGINS in check-plugins notification-plugins event-plugins; do
        if [[ ! -e $LFMP_DIR_DIST/$LFMP_TARGET_DISTRO/$PLUGINS/.fpm ]]; then
            continue;
        fi

        cd $LFMP_DIR_DIST/$LFMP_TARGET_DISTRO/$PLUGINS
        case "$LFMP_TARGET_DISTRO" in
        debian11)
            fpm --output-type deb
            ;;
        debian12)
            fpm --output-type deb
            ;;
        rhel8)
            fpm --output-type rpm
            ;;
        rhel9)
            fpm --output-type rpm
            ;;
        ubuntu2004)
            fpm --output-type deb
            fpm --output-type tar
            fpm --output-type zip
            ;;
        ubuntu2004)
            fpm --output-type deb
            ;;
        ubuntu2004)
            fpm --output-type deb
            ;;
        *)
            vendor="other"
            ;;
        esac
        cd

    done
done