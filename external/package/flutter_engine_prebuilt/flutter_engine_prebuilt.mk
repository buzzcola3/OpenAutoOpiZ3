################################################################################
# flutter_engine_prebuilt
################################################################################

FLUTTER_ENGINE_PREBUILT_VERSION = 78fc3012e45889657f72359b005af7beac47ba3d
FLUTTER_ENGINE_PREBUILT_SITE = https://github.com/ardera/flutter-ci/releases/download/engine%2F$(FLUTTER_ENGINE_PREBUILT_VERSION)
FLUTTER_ENGINE_PREBUILT_SOURCE = engine-aarch64-generic-release.tar.xz
FLUTTER_ENGINE_PREBUILT_EXTRA_DOWNLOADS = universal.tar.xz
FLUTTER_ENGINE_PREBUILT_SITE_METHOD = wget
FLUTTER_ENGINE_PREBUILT_LICENSE = Unknown
FLUTTER_ENGINE_PREBUILT_LICENSE_FILES =
FLUTTER_ENGINE_PREBUILT_INSTALL_TARGET = YES

define FLUTTER_ENGINE_PREBUILT_EXTRACT_CMDS
	mkdir -p $(@D)
	tar -xf $(DL_DIR)/flutter_engine_prebuilt/$(FLUTTER_ENGINE_PREBUILT_SOURCE) -C $(@D)
	tar -xf $(DL_DIR)/flutter_engine_prebuilt/universal.tar.xz -C $(@D)
endef

define FLUTTER_ENGINE_PREBUILT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libflutter_engine.so $(TARGET_DIR)/usr/lib/flutter-pi/engine/libflutter_engine.so
	$(INSTALL) -D -m 0644 $(@D)/icudtl.dat $(TARGET_DIR)/usr/lib/flutter-pi/engine/icudtl.dat
endef

$(eval $(generic-package))
