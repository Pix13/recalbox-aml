################################################################################
#
# mupen64plus video video-glide64mk2
#
################################################################################

MUPEN64PLUS_VIDEO_GLIDE64MK2_VERSION = 452d3ceeb7f50574ae5d39816669fb547709910f
MUPEN64PLUS_VIDEO_GLIDE64MK2_SITE = $(call github,mupen64plus,mupen64plus-video-glide64mk2,$(MUPEN64PLUS_VIDEO_GLIDE64MK2_VERSION))

MUPEN64PLUS_VIDEO_GLIDE64MK2_LICENSE = MIT
MUPEN64PLUS_VIDEO_GLIDE64MK2_DEPENDENCIES = sdl2 alsa-lib mupen64plus-core boost
MUPEN64PLUS_VIDEO_GLIDE64MK2_INSTALL_STAGING = YES

define MUPEN64PLUS_VIDEO_GLIDE64MK2_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
			PREFIX="$(STAGING_DIR)/usr" \
			PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
			HOST_CPU="$(MUPEN64PLUS_CORE_HOST_CPU)" \
			APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
			GL_CFLAGS="$(MUPEN64PLUS_CORE_GL_CFLAGS)" \
			GL_LDLIBS="$(MUPEN64PLUS_CORE_GL_LDLIBS)" \
			NO_SSE=1 \
			-C $(@D)/projects/unix all $(MUPEN64PLUS_CORE_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)"
endef

define MUPEN64PLUS_VIDEO_GLIDE64MK2_INSTALL_TARGET_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" CROSS_COMPILE="$(STAGING_DIR)/usr/bin/" \
			PREFIX="$(TARGET_DIR)/usr/" \
			PKG_CONFIG="$(HOST_DIR)/usr/bin/pkg-config" \
			HOST_CPU="$(MUPEN64PLUS_CORE_HOST_CPU)" \
			APIDIR="$(STAGING_DIR)/usr/include/mupen64plus" \
			GL_CFLAGS="$(MUPEN64PLUS_CORE_GL_CFLAGS)" \
			GL_LDLIBS="$(MUPEN64PLUS_CORE_GL_LDLIBS)" \
			INSTALL="/usr/bin/install" \
			INSTALL_STRIP_FLAG="" \
			-C $(@D)/projects/unix all $(MUPEN64PLUS_CORE_PARAMS) OPTFLAGS="$(TARGET_CXXFLAGS)" install
endef

define MUPEN64PLUS_VIDEO_GLIDE64MK2_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/projects/unix/Makefile
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/projects/unix/Makefile
endef

MUPEN64PLUS_VIDEO_GLIDE64MK2_PRE_CONFIGURE_HOOKS += MUPEN64PLUS_VIDEO_GLIDE64MK2_CROSS_FIXUP

$(eval $(generic-package))
