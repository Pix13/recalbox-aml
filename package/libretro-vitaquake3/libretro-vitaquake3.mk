################################################################################
#
# VITAQUAKE3
#
################################################################################

LIBRETRO_VITAQUAKE3_VERSION = 40e4f445fb4db71c479f5d8d04d6cad7d98b4cb7
LIBRETRO_VITAQUAKE3_SITE = $(call github,libretro,vitaquake3,$(LIBRETRO_VITAQUAKE3_VERSION))

define LIBRETRO_VITAQUAKE3_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_VITAQUAKE3_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/vitaquake3_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/vitaquake3_libretro.so
endef

$(eval $(generic-package))
