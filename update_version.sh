#!/bin/bash
set -euxo pipefail

# Read pkg name
PKG=$(awk -F '=' '/pkgname=/{ print $2 }' PKGBUILD)

# Get latest version date
VER_DATE=$(
  curl -sSf https://api.github.com/repos/Mm2PL/dankerino/commits/nightly-build |
    jq -r '.commit.author.date'
)
[[ -n $VER_DATE ]] || exit 1

VER=$(date -d ${VER_DATE} +%Y.%m.%d)

# Insert latest version into PKGBUILD
sed -i \
  -e "s/^pkgver=.*/pkgver=${VER}/" \
  PKGBUILD

# Check whether this changed anything
if (git diff --exit-code PKGBUILD); then
  echo "Package ${PKG} has most recent version ${VER}"
  exit 0
fi

# Reset pkgrel
sed -i \
  -e 's/pkgrel=.*/pkgrel=1/' \
  PKGBUILD

# Update source hashes
updpkgsums

# Update .SRCINFO
makepkg --printsrcinfo >.SRCINFO

# Commit changes
git add PKGBUILD .SRCINFO
git commit -m "${PKG} v${VER}"
