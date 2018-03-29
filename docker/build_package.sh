#!/usr/bin/env bash

rm sakia-linux.zip sakia-linux.deb

zip -r sakia-linux.zip dist/

# Debian package
chmod 755 ci/travis/debian/DEBIAN/post*
chmod 755 ci/travis/debian/DEBIAN/pre*
mkdir -p ci/travis/debian/opt/sakia

cp sakia.png ci/travis/debian/opt/sakia/
cp sakia-linux.zip ci/travis/debian/opt/sakia/sakia.zip
cp -r res/linux/usr ci/travis/debian
fakeroot dpkg-deb --build ci/travis/debian
mv ci/travis/debian.deb sakia-linux.deb
