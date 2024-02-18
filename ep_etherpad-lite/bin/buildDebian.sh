#!/usr/bin/env bash

# IMPORTANT
# Protect against misspelling a var and rm -rf /
set -u
set -e

ep_etherpad-lite=/tmp/etherpad-deb-ep_etherpad-lite
DIST=/tmp/etherpad-deb-dist
SYSROOT=${ep_etherpad-lite}/sysroot
DEBIAN=${ep_etherpad-lite}/DEBIAN

rm -rf ${DIST}
mkdir -p ${DIST}/

rm -rf ${ep_etherpad-lite}
rsync -a ep_etherpad-lite/bin/deb-ep_etherpad-lite/ ${ep_etherpad-lite}/
mkdir -p ${SYSROOT}/opt/

rsync --exclude '.git' -a . ${SYSROOT}/opt/etherpad/ --delete
mkdir -p ${SYSROOT}/usr/share/doc
cp README.md ${SYSROOT}/usr/share/doc/etherpad
find ${ep_etherpad-lite}/ -type d -exec chmod 0755 {} \;
find ${ep_etherpad-lite}/ -type f -exec chmod go-w {} \;
chown -R root:root ${ep_etherpad-lite}/

let SIZE=$(du -s ${SYSROOT} | sed s'/\s\+.*//')+8
pushd ${SYSROOT}/
tar czf ${DIST}/data.tar.gz [a-z]*
popd
sed s"/SIZE/${SIZE}/" -i ${DEBIAN}/control
pushd ${DEBIAN}
tar czf ${DIST}/control.tar.gz *
popd

pushd ${DIST}/
echo 2.0 > ./debian-binary

find ${DIST}/ -type d -exec chmod 0755 {} \;
find ${DIST}/ -type f -exec chmod go-w {} \;
chown -R root:root ${DIST}/
ar r ${DIST}/etherpad-1.deb debian-binary control.tar.gz data.tar.gz
popd
rsync -a ${DIST}/etherpad-1.deb ./
