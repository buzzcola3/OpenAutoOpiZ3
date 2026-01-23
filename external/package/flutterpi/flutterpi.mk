################################################################################
# flutterpi
################################################################################

FLUTTERPI_VERSION = 1.1.0
FLUTTERPI_SITE = https://github.com/ardera/flutter-pi/releases/download/release%2F$(FLUTTERPI_VERSION)
FLUTTERPI_SOURCE = flutterpi-aarch64-linux-gnu-release.tar.xz
FLUTTERPI_SITE_METHOD = wget
FLUTTERPI_LICENSE = MIT
FLUTTERPI_LICENSE_FILES =
FLUTTERPI_INSTALL_TARGET = YES


define FLUTTERPI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/flutter-pi $(TARGET_DIR)/usr/bin/flutter-pi
endef

$(eval $(generic-package))
