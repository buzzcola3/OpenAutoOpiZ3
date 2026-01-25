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

if [ -n "${TARGET_DIR}" ] && [ -d "${TARGET_DIR}/etc/init.d" ]; then
  chmod +x "${TARGET_DIR}/etc/init.d/S01psplash" "${TARGET_DIR}/etc/init.d/S99flutter-demo" 2>/dev/null || true
fi

if grep -Eq "^BR2_INIT_SYSTEMD=y$" "${BR2_CONFIG}"; then
  install -d "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants"
  ln -sf /etc/systemd/system/flutter-demo.service \
    "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/flutter-demo.service"
fi

if [ -f "${TARGET_DIR}/usr/lib/flutter-pi/engine/icudtl.dat" ]; then
  install -d "${TARGET_DIR}/usr/share/flutter"
  ln -sf /usr/lib/flutter-pi/engine/icudtl.dat "${TARGET_DIR}/usr/share/flutter/icudtl.dat"
fi
