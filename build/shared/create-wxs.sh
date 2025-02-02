#!/usr/bin/env bash

set -e -x

WXS_FILE="$1"
PACKAGE_VERSION=$2

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
