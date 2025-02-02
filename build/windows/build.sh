#!/usr/bin/env bash

set -e

PACKAGE_VERSION="$1"
PACKAGE_ITERATION="$2"
PACKAGE_ARCH="$3"
if [[ -z "$PACKAGE_VERSION" || -z "$PACKAGE_ITERATION" ]]; then
    echo "Usage: $(basename "$0") <PACKAGE_VERSION> <PACKAGE_ITERATION> <PACKAGE_ARCH> [<CHECK_PLUGIN>]"
    echo "  PACKAGE_VERSION: Version number starting with a digit (e.g. 2023123101) or 'main' for the latest development version."
    echo "  PACKAGE_ITERATION: Iteration number (e.g. 2) to specify the bugfix level for this package."
    echo "  PACKAGE_ARCH: Architecture. 'X64' (or 'x86_64'), 'ARM64' (or 'aarch64')."
    echo "  CHECK_PLUGIN: Optional. If you only want to compile a specific check plugin, specify its name, for example 'xml'."
    exit 1
fi
CHECK_PLUGIN="$4"
if [[ -z "$CHECK_PLUGIN" ]]; then
    CHECK_PLUGIN='*'
fi

CURRENT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
BUILD_SHARED_DIR="$CURRENT_DIR/../shared"
LIB_DIR="$CURRENT_DIR/../../lib"
MONITORING_PLUGINS_DIR="$CURRENT_DIR/../../"

if [[ ! -d "$LIB_DIR" ]]; then
    echo "The Python libraries (https://github.com/Linuxfabrik/lib) could not be found at $LIB_DIR."
    echo "They should be in a directory called 'lib' on the same level as the monitoring-plugins directory."
    exit 2
fi

# include shared functions
. "$BUILD_SHARED_DIR/shared.sh"

compile_plugins "$MONITORING_PLUGINS_DIR" "$CHECK_PLUGIN"

cat <<EOF > /c/tmp/lfmp.wxs
<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">
  <Package
      Name="Linuxfabrik Monitoring Plugins"
      Version="${{ PACKAGE_VERSION }}"
      Manufacturer="Linuxfabrik GmbH, Zurich, Switzerland"
      UpgradeCode="bb340ae1-12a5-41d3-a27f-8677df3bdb2b"
  >
      <StandardDirectory Id="CommonAppDataFolder">
          <Directory Id="Icinga2Dir" Name="icinga2">
              <Directory Id="UsrDir" Name="usr">
                  <Directory Id="Lib64Dir" Name="lib64">
                      <Directory Id="NagiosDir" Name="nagios">
                          <Directory Id="PluginsDir" Name="plugins">
                              <!-- Automatically includes all files from the specified directory -->
                              <Files Include="C:\tmp\output\summary\check-plugins\**" />
                          </Directory>
                      </Directory>
                  </Directory>
              </Directory>
          </Directory>
      </StandardDirectory>
  </Package>
</Wix>
EOF

