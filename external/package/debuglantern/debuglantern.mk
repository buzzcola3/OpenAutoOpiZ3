################################################################################
# debuglantern
################################################################################

DEBUGLANTERN_VERSION = 0.0.7
DEBUGLANTERN_SOURCE = debuglantern-linux-arm64-gnu.tar.gz
DEBUGLANTERN_SITE = https://github.com/buzzcola3/DebugLantern/releases/download/v$(DEBUGLANTERN_VERSION)
DEBUGLANTERN_SITE_METHOD = wget
DEBUGLANTERN_LICENSE = MIT
DEBUGLANTERN_LICENSE_FILES =
DEBUGLANTERN_INSTALL_TARGET = YES
DEBUGLANTERN_STRIP_COMPONENTS = 0

define DEBUGLANTERN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/debuglanternd $(TARGET_DIR)/opt/DebugLantern/debuglanternd
	$(INSTALL) -D -m 0755 $(@D)/debuglanternctl $(TARGET_DIR)/opt/DebugLantern/debuglanternctl
endef

$(eval $(generic-package))
