################################################################################
#
# recalbox-romfs-snes
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --system snes --extension '.smc .sfc .SMC .SFC .zip .ZIP .mgd .MGD' --fullname 'Super Nintendo Entertainment System' --platform snes --theme snes libretro:catsfc:BR2_PACKAGE_LIBRETRO_CATSFC libretro:pocketsnes:BR2_PACKAGE_LIBRETRO_POCKETSNES libretro:snes9x_next:BR2_PACKAGE_LIBRETRO_SNES9X_NEXT libretro:snes9x:BR2_PACKAGE_LIBRETRO_SNES9X

# Name the 3 vars as the package requires
RECALBOX_ROMFS_SNES_SOURCE =
RECALBOX_ROMFS_SNES_SITE =
# Set the system name
SYSTEM_NAME_SNES = snes
SYSTEM_XML_SNES = $(@D)/$(SYSTEM_NAME_SNES).xml
# System rom path
SOURCE_ROMDIR_SNES = $(RECALBOX_ROMFS_SNES_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot

ifneq ($(BR2_PACKAGE_LIBRETRO_CATSFC)$(BR2_PACKAGE_LIBRETRO_POCKETSNES)$(BR2_PACKAGE_LIBRETRO_SNES9X_NEXT)$(BR2_PACKAGE_LIBRETRO_SNES9X),)
define CONFIGURE_MAIN_SNES_START
	$(call RECALBOX_ROMFS_CALL_ADD_SYSTEM,$(SYSTEM_XML_SNES),Super Nintendo Entertainment System,$(SYSTEM_NAME_SNES),.smc .sfc .SMC .SFC .zip .ZIP .mgd .MGD,snes,snes)
endef

ifneq ($(BR2_PACKAGE_LIBRETRO_CATSFC)$(BR2_PACKAGE_LIBRETRO_POCKETSNES)$(BR2_PACKAGE_LIBRETRO_SNES9X_NEXT)$(BR2_PACKAGE_LIBRETRO_SNES9X),)
define CONFIGURE_SNES_LIBRETRO_START
	$(call RECALBOX_ROMFS_CALL_START_EMULATOR,$(SYSTEM_XML_SNES),libretro)
endef
ifeq ($(BR2_PACKAGE_LIBRETRO_SNES9X_NEXT),y)
define CONFIGURE_SNES_LIBRETRO_SNES9X_NEXT_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_SNES),snes9x_next)
endef
endif

ifeq ($(BR2_PACKAGE_LIBRETRO_CATSFC),y)
define CONFIGURE_SNES_LIBRETRO_CATSFC_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_SNES),catsfc)
endef
endif

ifeq ($(BR2_PACKAGE_LIBRETRO_SNES9X),y)
define CONFIGURE_SNES_LIBRETRO_SNES9X_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_SNES),snes9x)
endef
endif

ifeq ($(BR2_PACKAGE_LIBRETRO_POCKETSNES),y)
define CONFIGURE_SNES_LIBRETRO_POCKETSNES_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_SNES),pocketsnes)
endef
endif

define CONFIGURE_SNES_LIBRETRO_END
	$(call RECALBOX_ROMFS_CALL_END_EMULATOR,$(SYSTEM_XML_SNES))
endef
endif

define CONFIGURE_MAIN_SNES_END
	$(call RECALBOX_ROMFS_CALL_END_SYSTEM,$(SYSTEM_XML_SNES),$(SOURCE_ROMDIR_SNES),$(@D))
endef
endif

define RECALBOX_ROMFS_SNES_CONFIGURE_CMDS
	$(CONFIGURE_MAIN_SNES_START)
	$(CONFIGURE_SNES_LIBRETRO_START)
	$(CONFIGURE_SNES_LIBRETRO_SNES9X_NEXT_DEF)
	$(CONFIGURE_SNES_LIBRETRO_CATSFC_DEF)
	$(CONFIGURE_SNES_LIBRETRO_SNES9X_DEF)
	$(CONFIGURE_SNES_LIBRETRO_POCKETSNES_DEF)
	$(CONFIGURE_SNES_LIBRETRO_END)
	$(CONFIGURE_MAIN_SNES_END)
endef

$(eval $(generic-package))
