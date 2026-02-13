################################################################################
#
# openautoflutter
#
################################################################################

OPENAUTOFLUTTER_VERSION = 0.0.20
OPENAUTOFLUTTER_SOURCE = openautoflutter_example-flutter-pi-arm64.tar.gz
OPENAUTOFLUTTER_SITE = https://github.com/buzzcola3/OpenAutoFlutter/releases/download/v$(OPENAUTOFLUTTER_VERSION)
OPENAUTOFLUTTER_SITE_METHOD = wget
OPENAUTOFLUTTER_LICENSE = Proprietary
OPENAUTOFLUTTER_LICENSE_FILES =
OPENAUTOFLUTTER_INSTALL_TARGET = YES
OPENAUTOFLUTTER_STRIP_COMPONENTS = 0

define OPENAUTOFLUTTER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/OpenAutoFlutter
	cp -a $(@D)/* $(TARGET_DIR)/opt/OpenAutoFlutter/
	rm -f $(TARGET_DIR)/opt/OpenAutoFlutter/run_bundle.sh
	chmod 755 $(TARGET_DIR)/opt/OpenAutoFlutter/flutter-pi
endef

$(eval $(generic-package))
