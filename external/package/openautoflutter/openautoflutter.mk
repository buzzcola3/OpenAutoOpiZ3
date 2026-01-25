################################################################################
#
# openautoflutter
#
################################################################################

OPENAUTOFLUTTER_VERSION = 0.0.2
OPENAUTOFLUTTER_SITE = https://github.com/buzzcola3/OpenAutoFlutter/releases/download/v$(OPENAUTOFLUTTER_VERSION)
OPENAUTOFLUTTER_SOURCE = openautoflutter_example-linux-arm64.tar.gz
OPENAUTOFLUTTER_LICENSE = UNKNOWN

OPENAUTOFLUTTER_INSTALL_DIR = $(TARGET_DIR)/usr/share/flutter/demo

define OPENAUTOFLUTTER_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(OPENAUTOFLUTTER_INSTALL_DIR)
	cp -a $(@D)/data/flutter_assets $(OPENAUTOFLUTTER_INSTALL_DIR)/
	cp -a $(@D)/lib/libapp.so $(OPENAUTOFLUTTER_INSTALL_DIR)/
	ln -sf libapp.so $(OPENAUTOFLUTTER_INSTALL_DIR)/app.so
endef

$(eval $(generic-package))
