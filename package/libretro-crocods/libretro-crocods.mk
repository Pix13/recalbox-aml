################################################################################
#
# CROCODS
#
################################################################################

LIBRETRO_CROCODS_VERSION = fc161752446368195f9718a4ff749db9387e0747
LIBRETRO_CROCODS_SITE = $(call github,libretro,libretro-crocods,$(LIBRETRO_CROCODS_VERSION))

define LIBRETRO_CROCODS_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_CROCODS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/crocods_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/crocods_libretro.so
endef

$(eval $(generic-package))
