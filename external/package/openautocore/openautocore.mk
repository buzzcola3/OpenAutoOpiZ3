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

# Enable Cedrus V4L2 M2M hardware video decoding (staging driver).
# Intermediate olddefconfig passes are needed because STAGING children
# are invisible until their parent menuconfig is enabled. Each pass
# populates the next level of entries so in-place sed can match them.
define OPENAUTOCORE_LINUX_CONFIG_FIXUPS
	$(SED) 's/^# CONFIG_STAGING is not set/CONFIG_STAGING=y/' $(LINUX_DIR)/.config
	$(SED) 's/^# CONFIG_MEDIA_SUPPORT_FILTER is not set/CONFIG_MEDIA_SUPPORT_FILTER=y/' $(LINUX_DIR)/.config
	$(SED) 's/^# CONFIG_MEDIA_PLATFORM_SUPPORT is not set/CONFIG_MEDIA_PLATFORM_SUPPORT=y/' $(LINUX_DIR)/.config
	$(SED) 's/^# CONFIG_V4L_MEM2MEM_DRIVERS is not set/CONFIG_V4L_MEM2MEM_DRIVERS=y/' $(LINUX_DIR)/.config
	$(LINUX_MAKE_ENV) $(BR2_MAKE) $(LINUX_MAKE_FLAGS) HOSTCC="$(HOSTCC_NOCCACHE)" -C $(LINUX_DIR) olddefconfig
	$(SED) 's/^# CONFIG_STAGING_MEDIA is not set/CONFIG_STAGING_MEDIA=y/' $(LINUX_DIR)/.config
	$(LINUX_MAKE_ENV) $(BR2_MAKE) $(LINUX_MAKE_FLAGS) HOSTCC="$(HOSTCC_NOCCACHE)" -C $(LINUX_DIR) olddefconfig
	$(SED) 's/^# CONFIG_VIDEO_SUNXI is not set/CONFIG_VIDEO_SUNXI=y/' $(LINUX_DIR)/.config
	$(LINUX_MAKE_ENV) $(BR2_MAKE) $(LINUX_MAKE_FLAGS) HOSTCC="$(HOSTCC_NOCCACHE)" -C $(LINUX_DIR) olddefconfig
	$(SED) 's/^# CONFIG_VIDEO_SUNXI_CEDRUS is not set/CONFIG_VIDEO_SUNXI_CEDRUS=m/' $(LINUX_DIR)/.config
endef

$(eval $(generic-package))
