#!/bin/bash

set -e

if [[ ! -d /var/lib/openqa/tests/almalinux ]]; then
  cd /var/lib/openqa/tests/
  sudo git clone https://github.com/srbala/os-autoinst-distri-almalinux.git almalinux
  sudo chown -R geekotest:geekotest almalinux
  cd almalinux
  git config --global --add safe.directory /var/lib/openqa/share/tests/almalinux
  sudo git checkout develop
fi
cd /var/lib/openqa/tests/almalinux && sudo ./fifloader.py -l -c templates.fif.json templates-updates.fif.json

sudo mkdir -p /var/lib/openqa/share/factory/iso/fixed
if [[ ! -f /var/lib/openqa/share/factory/iso/fixed/CHECKSUM ]]; then
  cd /var/lib/openqa/share/factory/iso/fixed
  sudo curl -C - -O https://repo.almalinux.org/almalinux/8/isos/x86_64/AlmaLinux-8.6-x86_64-boot.iso
  sudo curl -C - -O https://repo.almalinux.org/almalinux/8/isos/x86_64/AlmaLinux-8.6-x86_64-minimal.iso 
  sudo curl -C - -O https://repo.almalinux.org/almalinux/8/isos/x86_64/AlmaLinux-8.6-x86_64-dvd.iso 
  sudo curl -C - -O https://repo.almalinux.org/almalinux/8/isos/x86_64/CHECKSUM
  shasum -a 256 --ignore-missing -c CHECKSUM
fi

echo Now post a new job for almalinux :-\)
sudo openqa-cli api -X POST isos \
  ISO=AlmaLinux-8.6-x86_64-minimal.iso \
  ARCH=x86_64 \
  DISTRI=almalinux \
  FLAVOR=minimal-iso \
  VERSION=8.6 \
  BUILD="$(date +%Y%m%d.%H%M%S).0"

echo Scheduled job should be started by worker!

echo Here is the jobs overview provided by openqa-cli api...
echo "openqa-cli api -X GET --pretty jobs/overview"
openqa-cli api -X GET --pretty jobs/overview

echo Here is the job detail for the first job...
echo "openqa-cli api -X GET --pretty jobs/1"
openqa-cli api -X GET --pretty jobs/1
