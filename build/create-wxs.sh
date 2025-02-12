#!/usr/bin/env bash

set -e -x

cat > "$LFMP_DIR_PACKAGED/lfmp.wxs" << EOF
<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">
  <Product
      Manufacturer="Linuxfabrik GmbH"
      Name="Linuxfabrik Monitoring Plugins"
      UpgradeCode="bb340ae1-12a5-41d3-a27f-8677df3b8032"
      Version="$LFMP_VERSION">
      
    <!-- Package: Only package-level settings go here -->
    <Package>
      <MediaTemplate EmbedCab="yes"/>
    </Package>

    <!-- The directory tree must be defined under Product, typically starting with TARGETDIR -->
    <Directory Id="TARGETDIR" Name="SourceDir">
      <Directory Id="CommonAppDataFolder">
        <Directory Id="Icinga2Dir" Name="icinga2">
          <Directory Id="UsrDir" Name="usr">
            <Directory Id="Lib64Dir" Name="lib64">
              <Directory Id="NagiosDir" Name="nagios">
                <Directory Id="PluginsDir" Name="plugins">
                  <!-- Define the component within the directory where its files (or actions) reside -->
                  <Component Id="PluginComponent" Guid="*">
                    <!-- Automatically include all files from the specified directory -->
                    <Files Include="$LFMP_DIR_DIST\**" />
                    <!-- Service control needs to be placed in a component -->
                    <ServiceControl
                        Id="icinga2"
                        Name="Icinga 2"
                        Start="both"
                        Stop="both"
                        Wait="yes"/>
                  </Component>
                </Directory>
              </Directory>
            </Directory>
          </Directory>
        </Directory>
      </Directory>
    </Directory>

    <!-- Feature: Reference the component so it gets installed -->
    <Feature Id="MainFeature" Title="Linuxfabrik Monitoring Plugins" Level="1">
      <ComponentRef Id="PluginComponent"/>
    </Feature>

  </Product>
</Wix>
EOF
echo $(cat "$LFMP_DIR_PACKAGED/lfmp.wxs")

# See
# * https://docs.firegiant.com/wix3/xsd/wix/product/
# * https://docs.firegiant.com/wix3/xsd/wix/package/
# * https://docs.firegiant.com/wix3/xsd/wix/component/
# and other.