#!/usr/bin/env bash

set -e -x

cat > "$LFMP_DIR_PACKAGED/lfmp.wxs" << EOF
<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">
  <Package
      Name="Linuxfabrik Monitoring Plugins"
      Version="$LFMP_VERSION"
      Manufacturer="Linuxfabrik GmbH"
      UpgradeCode="bb340ae1-12a5-41d3-a27f-8677df3b8032"
  >
      <MediaTemplate EmbedCab="yes" />
      <StandardDirectory Id="CommonAppDataFolder">
          <Directory Id="Icinga2Dir" Name="icinga2">
              <Directory Id="UsrDir" Name="usr">
                  <Directory Id="Lib64Dir" Name="lib64">
                      <Directory Id="NagiosDir" Name="nagios">
                          <Directory Id="PluginsDir" Name="plugins">
                              <!-- Automatically includes all files from the specified directory -->
                              <Files Include="$LFMP_DIR_DIST\**" />
                          </Directory>
                      </Directory>
                  </Directory>
              </Directory>
          </Directory>
      </StandardDirectory>
  </Package>
</Wix>
EOF
echo $(cat "$LFMP_DIR_PACKAGED/lfmp.wxs")
