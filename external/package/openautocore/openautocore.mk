################################################################################
# openautocore
################################################################################

OPENAUTOCORE_VERSION = 0.0.2
OPENAUTOCORE_SOURCE = openautocore-arm64_gnu.tar.gz
OPENAUTOCORE_SITE = https://github.com/buzzcola3/OpenAutoCore/releases/download/v$(OPENAUTOCORE_VERSION)
OPENAUTOCORE_SITE_METHOD = wget
OPENAUTOCORE_LICENSE = Proprietary
OPENAUTOCORE_LICENSE_FILES =
OPENAUTOCORE_INSTALL_TARGET = YES
OPENAUTOCORE_STRIP_COMPONENTS = 1

define OPENAUTOCORE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/OpenAutoCore
	cp -a $(@D)/configuration $(TARGET_DIR)/opt/OpenAutoCore/
	$(INSTALL) -D -m 0755 $(@D)/openautocore $(TARGET_DIR)/opt/OpenAutoCore/openautocore
endef

$(eval $(generic-package))
