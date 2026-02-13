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

## Installed Packages

Packages added on top of the default Buildroot configuration:

| Package | Source | Install path | Description |
|---|---|---|---|
| OpenAutoCore | [external](external/package/openautocore/) | `/usr/bin/openautocore` | Core OpenAuto binary (prebuilt) |
| OpenAutoFlutter | [external](external/package/openautoflutter/) | `/opt/OpenAutoFlutter/` | Prebuilt Flutter UI (flutter-pi bundle, v0.0.20) |
| LLVM | Buildroot | `/usr/lib/` | Required by Mesa Panfrost gallium driver |
| Mesa3D (Panfrost) | Buildroot | `/usr/lib/` | GPU drivers — EGL, GLES, GBM, Panfrost + kmsro gallium |
| Vulkan Loader | Buildroot | `/usr/lib/` | Vulkan ICD loader |
| libdrm | Buildroot | `/usr/lib/` | Direct Rendering Manager library |
| libinput | Buildroot | `/usr/lib/` | Input device handling |
| libxkbcommon | Buildroot | `/usr/lib/` | Keyboard keymap handling |
| xkeyboard-config | Buildroot | `/usr/share/X11/xkb/` | XKB keyboard layout data |
| GTK 3 | Buildroot | `/usr/lib/` | Widget toolkit (+ cairo, pango, atk, gdk-pixbuf) |
| libepoxy | Buildroot | `/usr/lib/` | GL function pointer dispatch |
| FFmpeg | Buildroot | `/usr/lib/` | libavcodec, libavutil, libswscale |
| GStreamer 1.x | Buildroot | `/usr/lib/` | Media pipeline framework + base plugins |
| fontconfig / freetype / harfbuzz | Buildroot | `/usr/lib/` | Font rendering stack |
| DejaVu fonts | Buildroot | `/usr/share/fonts/` | Default font family |
| systemd | Buildroot | `/usr/lib/systemd/` | Init system, libudev, libsystemd |
| libc++ / libc++abi / libunwind | Rootfs overlay (LLVM 18, aarch64) | `/usr/lib/` | LLVM C++ runtime (required by OpenAutoFlutter plugin) |

## Usage

OpenAutoFlutter does **not** start automatically. A systemd unit (`openautoflutter.service`) is included but not enabled by default. It requires `openautocore` to be running first — it connects via shared memory transport as Side B.

To run manually:

```bash
# Start OpenAutoCore first (Side A)
openautocore &

# Then start OpenAutoFlutter
cd /opt/OpenAutoFlutter && LD_LIBRARY_PATH=/opt/OpenAutoFlutter ./flutter-pi --release /opt/OpenAutoFlutter
```

If fbcon is holding the DRM device, release it first:

```bash
echo 0 > /sys/class/vtconsole/vtcon1/bind 2>/dev/null
```

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
