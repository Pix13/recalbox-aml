################################################################################
#
# O2EM
#
################################################################################

LIBRETRO_O2EM_VERSION = 32182d2b2d2a8c2455db3b06b65aa7e01505c020
LIBRETRO_O2EM_SITE = $(call github,libretro,libretro-o2em,$(LIBRETRO_O2EM_VERSION))

define LIBRETRO_O2EM_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_O2EM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/o2em_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/o2em_libretro.so
endef

$(eval $(generic-package))
