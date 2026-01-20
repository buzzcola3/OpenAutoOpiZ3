# OpenAuto Buildroot (Orange Pi Zero 3)

Minimal Buildroot setup targeting Orange Pi Zero 3 (Allwinner H618). Includes the latest OpenAutoCore prebuilt binary and serves as a base for adding OpenAuto packages later.

OpenAutoCore binary is installed at /usr/bin/openautocore in the target rootfs.

## Build

From the project root:

- Configure:
  - `make -C buildroot BR2_EXTERNAL=../external openauto_orangepi_zero3_defconfig`
- Build:
  - `make -C buildroot`

Build outputs are in `buildroot/output/images`.
