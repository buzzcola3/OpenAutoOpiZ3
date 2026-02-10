# OpenAuto Buildroot (Orange Pi Zero 3)

Minimal Buildroot setup targeting Orange Pi Zero 3 (Allwinner H618). Includes the latest OpenAutoCore prebuilt binary and serves as a base for adding OpenAuto packages later.

OpenAutoCore binary is installed at /usr/bin/openautocore in the target rootfs.

## Build

From the project root:

- Grab Buildroot (keep a local clone under `buildroot/`):
  - `git clone https://github.com/buildroot/buildroot.git buildroot`
- Configure:
  - `make -C buildroot BR2_EXTERNAL=../external openauto_orangepi_zero3_defconfig`
- Build:
  - `make -C buildroot`

Build outputs are in `buildroot/output/images`.

## Debug / Development Notes

> Items in this section are for development convenience and should be reverted before a release build.

### Verbose UART Boot Logging

The following changes enable maximum kernel logging over UART for debugging:

- **`external/board/orangepi/zero3/extlinux.conf`** — `quiet` removed; `loglevel=8 earlycon printk.devkmsg=on initcall_debug ignore_loglevel` added to the kernel command line.
- **`external/kernel-fragments/no_boot_console.fragment`** — enables `CONFIG_EARLY_PRINTK`, `CONFIG_PRINTK_TIME`, `CONFIG_DYNAMIC_DEBUG`, `CONFIG_DEBUG_KERNEL`, `CONFIG_FTRACE`, etc.
- **`external/configs/openauto_orangepi_zero3_defconfig`** — the `no_boot_console.fragment` is appended to `BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES`.

**To revert for release:**
1. In `extlinux.conf`, restore `quiet loglevel=3 consoleblank=0 vt.global_cursor_default=0 logo.nologo fbcon=map:0` and remove `earlycon`, `printk.devkmsg=on`, `initcall_debug`, `ignore_loglevel`.
2. In `no_boot_console.fragment`, restore the console-suppressing options (`CONFIG_VT=n`, `CONFIG_FRAMEBUFFER_CONSOLE=n`, etc.).
3. In the defconfig, remove `../external/kernel-fragments/no_boot_console.fragment` from the fragment list.
