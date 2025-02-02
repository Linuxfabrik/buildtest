#!/usr/bin/env bash

set -e -x

WXS_FILE="$1"
PACKAGE_VERSION=$2
DIST_FOLDER=$3

# Extract the drive letter (character after the initial slash)
drive="${DIST_FOLDER:1:1}"

# Extract the rest of the path (everything after the drive letter)
rest="${DIST_FOLDER:2}"

# Replace all forward slashes with backslashes in the rest of the path
windows_rest="${rest//\//\\}"

# Construct the Windows-style path (convert drive letter to uppercase)
windows_path="${drive^^}:$windows_rest"


cat <<EOF > $WXS_FILE
<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">
  <Package
      Name="Linuxfabrik Monitoring Plugins"
      Version="$PACKAGE_VERSION"
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
                              <Files Include="$windows_path\**" />
                          </Directory>
                      </Directory>
                  </Directory>
              </Directory>
          </Directory>
      </StandardDirectory>
  </Package>
</Wix>
EOF
