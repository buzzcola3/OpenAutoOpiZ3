#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

linux_image() {
  if grep -Eq "^BR2_LINUX_KERNEL_UIMAGE=y$" "${BR2_CONFIG}"; then
    echo "uImage"
  elif grep -Eq "^BR2_LINUX_KERNEL_IMAGE=y$" "${BR2_CONFIG}"; then
    echo "Image"
  elif grep -Eq "^BR2_LINUX_KERNEL_IMAGEGZ=y$" "${BR2_CONFIG}"; then
    echo "Image.gz"
  else
    echo "zImage"
  fi
}

generic_getty() {
  if grep -Eq "^BR2_TARGET_GENERIC_GETTY=y$" "${BR2_CONFIG}"; then
    echo ""
  else
    echo "s/\\s*console=\\S*//"
  fi
}

PARTUUID="$(${HOST_DIR}/bin/uuidgen)"

install -d "${TARGET_DIR}/boot/extlinux/"

sed -e "$(generic_getty)" \
  -e "s/%LINUXIMAGE%/$(linux_image)/g" \
  -e "s/%PARTUUID%/${PARTUUID}/g" \
  "${SCRIPT_DIR}/extlinux.conf" > "${TARGET_DIR}/boot/extlinux/extlinux.conf"

sed "s/%PARTUUID%/${PARTUUID}/g" "${SCRIPT_DIR}/genimage.cfg" > "${BINARIES_DIR}/genimage.cfg"

mkdir -p "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants"
rm -f "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/openautocore.service"
rm -f "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/openautoflutter.service"
ln -sf /usr/lib/systemd/system/systemd-networkd.service \
  "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/systemd-networkd.service"
ln -sf /usr/lib/systemd/system/avahi-daemon.service \
  "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/avahi-daemon.service"
ln -sf /etc/systemd/system/debuglantern.service \
  "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/debuglantern.service"
