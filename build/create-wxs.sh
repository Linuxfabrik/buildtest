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

      <!-- https://docs.firegiant.com/wix3/xsd/wix/mediatemplate/ -->
      <MediaTemplate EmbedCab="yes" />

      <!-- https://docs.firegiant.com/wix3/xsd/wix/servicecontrol/ -->
      <!-- Stop/Start Icinga-Agent on Install/Uninstall
      <ServiceControl
          Id="icinga2"
          Name="Icinga 2"
          Stop="both"
          Start="both"
          Wait="yes"
      />

      <!-- Deploy to C:\ProgramData\icinga2\usr\lib64\nagios\plugins -->
      <StandardDirectory Id="CommonAppDataFolder">
          <Directory Id="Icinga2Dir" Name="icinga2">
              <Directory Id="UsrDir" Name="usr">
                  <Directory Id="Lib64Dir" Name="lib64">
                      <Directory Id="NagiosDir" Name="nagios">
                          <Directory Id="PluginsDir" Name="plugins">
                              <!-- Automatically include all files from the specified directory -->
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
