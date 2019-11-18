################################################################################
#
# VITAVOYAGER
#
################################################################################

LIBRETRO_VITAVOYAGER_VERSION = 4662831ae4154135f682cf5d266aac5868017e43
LIBRETRO_VITAVOYAGER_SITE = $(call github,libretro,vitaVoyager,$(LIBRETRO_VITAVOYAGER_VERSION))

define LIBRETRO_VITAVOYAGER_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_VITAVOYAGER_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/vitavoyager_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/vitavoyager_libretro.so
endef

$(eval $(generic-package))
