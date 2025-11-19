#!/bin/bash

echo "Checking latest version"

latest=$(curl -s https://api.github.com/repos/brave/brave-browser/releases \
        | grep -o '"name": "brave-browser_[0-9]\+\.[0-9]\+\.[0-9]\+_amd64.deb"' \
        | head -n 1 \
        | sed -E 's/.*brave-browser_([0-9]+\.[0-9]+\.[0-9]+)_amd64.deb.*/\1/')

echo "Latest version available: $latest"


current=$(cat template | grep version= | cut -c9-)
echo "Current template version is: $current"

if [ "$latest" = "$current" ]; then
    echo "No update required"
    exit 0
fi

export version=$latest
export download=https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb
echo "Downloading Brave to get checksum"


name="brave-latest.deb"

curl -o "$name" -LOs "$download"
export checksum=$(sha256sum "$name" | awk '{ print $1 }')
echo "Checksum computed"
rm "$name"

sed "s|\${version}|$version|g; s|\${checksum}|$checksum|g" ./model > template
echo "Template updated"
