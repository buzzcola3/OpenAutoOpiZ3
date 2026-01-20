################################################################################
# openautocore
################################################################################

OPENAUTOCORE_VERSION = 0.0.1
OPENAUTOCORE_SITE = https://github.com/buzzcola3/OpenAutoCore/releases/download/v$(OPENAUTOCORE_VERSION)
OPENAUTOCORE_SOURCE = openautocore-arm64_gnu
OPENAUTOCORE_SITE_METHOD = wget
OPENAUTOCORE_LICENSE = Proprietary
OPENAUTOCORE_LICENSE_FILES =
OPENAUTOCORE_INSTALL_TARGET = YES

ifeq ($(BR2_aarch64),y)
OPENAUTOCORE_TARGET = openautocore
else
OPENAUTOCORE_TARGET = openautocore
endif

define OPENAUTOCORE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(OPENAUTOCORE_SOURCE) $(TARGET_DIR)/usr/bin/$(OPENAUTOCORE_TARGET)
endef

define OPENAUTOCORE_EXTRACT_CMDS
	$(INSTALL) -D -m 0755 $(DL_DIR)/openautocore/$(OPENAUTOCORE_SOURCE) $(@D)/$(OPENAUTOCORE_SOURCE)
endef

$(eval $(generic-package))
