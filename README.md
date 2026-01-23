# OpenAuto Buildroot (Orange Pi Zero 3)

Minimal Buildroot setup targeting Orange Pi Zero 3 (Allwinner H618). Includes the latest OpenAutoCore prebuilt binary and serves as a base for adding OpenAuto packages later.

OpenAutoCore binary is installed at /usr/bin/openautocore in the target rootfs.

## flutter-pi (DRM/KMS)

This build includes flutter-pi (release/1.1.0) and a prebuilt Flutter engine (3.38.6, engine 78fc3012e45889657f72359b005af7beac47ba3d).

Installed paths:
- /usr/bin/flutter-pi
- /usr/lib/flutter-pi/engine/libflutter_engine.so
- /usr/lib/flutter-pi/engine/icudtl.dat

Demo autostart (placeholder):
- Init script: /etc/init.d/S99flutter-demo
- Demo location: /usr/share/flutter/demo
Place your Flutter app output (flutter_assets/ and libapp.so) there to get HDMI output.

## Build

From the project root:

- Grab Buildroot (keep a local clone under `buildroot/`):
  - `git clone https://github.com/buildroot/buildroot.git buildroot`
- Configure:
  - `make -C buildroot BR2_EXTERNAL=../external openauto_orangepi_zero3_defconfig`
- Build:
  - `make -C buildroot`

Build outputs are in `buildroot/output/images`.
