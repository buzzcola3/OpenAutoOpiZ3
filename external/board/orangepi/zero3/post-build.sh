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

# Strip debug symbols from LLVM/Clang/SPIRV toolchain libraries.
# With BR2_ENABLE_DEBUG + BR2_STRIP_none, these exceed the 2 GB
# single-file limit of mkfs.ext4 -d (e2fsprogs populate mode).
# We don't need to debug these on-target, so strip them to keep the
# image buildable while preserving symbols for every other package.
if grep -Eq "^BR2_ENABLE_DEBUG=y$" "${BR2_CONFIG}"; then
  for f in "${TARGET_DIR}"/usr/lib/libLLVM*.so* \
           "${TARGET_DIR}"/usr/lib/libclang*.so* \
           "${TARGET_DIR}"/usr/lib/libSPIRV*.so*; do
    [ -L "$f" ] && continue
    [ -f "$f" ] || continue
    echo "Stripping debug symbols from $(basename "$f")"
    "${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-strip" --strip-debug "$f"
  done
fi
