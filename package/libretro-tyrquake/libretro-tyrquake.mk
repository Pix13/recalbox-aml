################################################################################
#
# TYRQUAKE
#
################################################################################

LIBRETRO_TYRQUAKE_VERSION = 53137f9aa7ac45837c6f4b261cd9fa6a9a5da87e
LIBRETRO_TYRQUAKE_SITE = $(call github,libretro,tyrquake,$(LIBRETRO_TYRQUAKE_VERSION))

define LIBRETRO_TYRQUAKE_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_TYRQUAKE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/tyrquake_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/tyrquake_libretro.so
endef

$(eval $(generic-package))
