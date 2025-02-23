#!/usr/bin/env bash
# 2025022303

set -e -x

cat > "$LFMP_DIR_PACKAGED/in/lfmp.wxs" << EOF
<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">
    <Package
        Name="Linuxfabrik Monitoring Plugins"
        Manufacturer="Linuxfabrik GmbH"
        Version="$LFMP_VERSION"
        InstallerVersion="200"
        UpgradeCode="{bb340ae1-12a5-41d3-a27f-8677df3b8032}">

        <MediaTemplate EmbedCab="yes" />

        <StandardDirectory Id="ProgramFiles64Folder">
            <Directory Id="Icinga2Dir" Name="icinga2">
                <Directory Id="SBinDir" Name="sbin">
                    <Directory Id="LinuxfabrikDir" Name="linuxfabrik">
                        <!-- Automatically includes all files from the specified directory -->
                        <Files Include="$LFMP_DIR_COMPILED\check-plugins\**" />
                        <Component Id="Icinga2ServiceControl" Guid="{7e398e63-b894-47d1-9375-eea744988032}">
                            <ServiceControl
                                Id="icinga2"
                                Name="icinga2"
                                Start="both"
                                Stop="both"
                                Wait="yes"/>
                        </Component>
                    </Directory>
                </Directory>
            </Directory>
        </StandardDirectory>

    </Package>
</Wix>
EOF
echo $(cat "$LFMP_DIR_PACKAGED/in/lfmp.wxs")

# The above file is WiX v5 syntax. See the older docs:
# * https://docs.firegiant.com/wix3/xsd/wix/product/
# * https://docs.firegiant.com/wix3/xsd/wix/package/
# * https://docs.firegiant.com/wix3/xsd/wix/component/
# and other.

# WIX1148: Invalid MSI package version: '2025022901'. The Windows Installer SDK says that MSI
# package versions must have a major version less than 256, a minor version less than 256,
# and a build version less than 65536. The revision value is ignored but version labels and
# metadata are not allowed. Violating the MSI rules sometimes works as expected but the
# behavior is unpredictable and undefined. Future versions of WiX might treat invalid package
# versions as an error.
