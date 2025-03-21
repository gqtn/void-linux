#!/bin/bash

echo "Checking latest version"

latest=$(gh api repos/ONLYOFFICE/DesktopEditors/releases/latest |jq -r .tag_name |cut -c2-)
echo "Latest version available: $latest"


current=$(cat template | grep version= | cut -c9-)
echo "Current template version is: $current"

if [ "$latest" = "$current" ]; then
    echo "No update required"
    exit 0
fi

export version=$latest
export download="https://github.com/ONLYOFFICE/DesktopEditors/releases/download/v${version}/onlyoffice-desktopeditors_amd64.deb"
echo "Downloading file to get checksum"

name="onlyoffice.deb"

curl -o "$name" -LOs "$download"
export checksum=$(sha256sum "$name" | awk '{ print $1 }')
echo "Checksum computed"
rm "$name"

sed "s|\${version}|$version|g; s|\${checksum}|$checksum|g" ./model > template
echo "Template updated"
