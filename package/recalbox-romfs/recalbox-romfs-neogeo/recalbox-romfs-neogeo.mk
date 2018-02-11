################################################################################
#
# recalbox-romfs-neogeo
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --system neogeo --extension '.zip .ZIP' --fullname 'Neo-Geo' --platform neogeo --theme neogeo libretro:mame078:BR2_PACKAGE_LIBRETRO_MAME2003 libretro:imame4all:BR2_PACKAGE_LIBRETRO_IMAME libretro:fba:BR2_PACKAGE_LIBRETRO_FBA fba2x:fba2x:BR2_PACKAGE_PIFBA libretro:mame2010:BR2_PACKAGE_LIBRETRO_MAME2010

# Name the 3 vars as the package requires
RECALBOX_ROMFS_NEOGEO_SOURCE =
RECALBOX_ROMFS_NEOGEO_SITE =
# Set the system name
SYSTEM_NAME_NEOGEO = neogeo
SYSTEM_XML_NEOGEO = $(@D)/$(SYSTEM_NAME_NEOGEO).xml
# System rom path
SOURCE_ROMDIR_NEOGEO = $(RECALBOX_ROMFS_NEOGEO_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot

ifneq ($(BR2_PACKAGE_LIBRETRO_MAME2003)$(BR2_PACKAGE_LIBRETRO_IMAME)$(BR2_PACKAGE_LIBRETRO_FBA)$(BR2_PACKAGE_PIFBA)$(BR2_PACKAGE_LIBRETRO_MAME2010),)
define CONFIGURE_MAIN_NEOGEO_START
	$(call RECALBOX_ROMFS_CALL_ADD_SYSTEM,$(SYSTEM_XML_NEOGEO),Neo-Geo,$(SYSTEM_NAME_NEOGEO),.zip .ZIP,neogeo,neogeo)
endef

ifneq ($(BR2_PACKAGE_LIBRETRO_MAME2003)$(BR2_PACKAGE_LIBRETRO_IMAME)$(BR2_PACKAGE_LIBRETRO_FBA)$(BR2_PACKAGE_PIFBA)$(BR2_PACKAGE_LIBRETRO_MAME2010),)
define CONFIGURE_NEOGEO_LIBRETRO_START
	$(call RECALBOX_ROMFS_CALL_START_EMULATOR,$(SYSTEM_XML_NEOGEO),libretro)
endef
ifeq ($(BR2_PACKAGE_LIBRETRO_MAME2010),y)
define CONFIGURE_NEOGEO_LIBRETRO_MAME2010_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_NEOGEO),mame2010)
endef
endif

ifeq ($(BR2_PACKAGE_LIBRETRO_MAME2003),y)
define CONFIGURE_NEOGEO_LIBRETRO_MAME078_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_NEOGEO),mame078)
endef
endif

ifeq ($(BR2_PACKAGE_LIBRETRO_FBA),y)
define CONFIGURE_NEOGEO_LIBRETRO_FBA_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_NEOGEO),fba)
endef
endif

ifeq ($(BR2_PACKAGE_LIBRETRO_IMAME),y)
define CONFIGURE_NEOGEO_LIBRETRO_IMAME4ALL_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_NEOGEO),imame4all)
endef
endif

define CONFIGURE_NEOGEO_LIBRETRO_END
	$(call RECALBOX_ROMFS_CALL_END_EMULATOR,$(SYSTEM_XML_NEOGEO))
endef
endif

ifneq ($(BR2_PACKAGE_LIBRETRO_MAME2003)$(BR2_PACKAGE_LIBRETRO_IMAME)$(BR2_PACKAGE_LIBRETRO_FBA)$(BR2_PACKAGE_PIFBA)$(BR2_PACKAGE_LIBRETRO_MAME2010),)
define CONFIGURE_NEOGEO_FBA2X_START
	$(call RECALBOX_ROMFS_CALL_START_EMULATOR,$(SYSTEM_XML_NEOGEO),fba2x)
endef
ifeq ($(BR2_PACKAGE_PIFBA),y)
define CONFIGURE_NEOGEO_FBA2X_FBA2X_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_NEOGEO),fba2x)
endef
endif

define CONFIGURE_NEOGEO_FBA2X_END
	$(call RECALBOX_ROMFS_CALL_END_EMULATOR,$(SYSTEM_XML_NEOGEO))
endef
endif

define CONFIGURE_MAIN_NEOGEO_END
	$(call RECALBOX_ROMFS_CALL_END_SYSTEM,$(SYSTEM_XML_NEOGEO),$(SOURCE_ROMDIR_NEOGEO),$(@D))
endef
endif

define RECALBOX_ROMFS_NEOGEO_CONFIGURE_CMDS
	$(CONFIGURE_MAIN_NEOGEO_START)
	$(CONFIGURE_NEOGEO_LIBRETRO_START)
	$(CONFIGURE_NEOGEO_LIBRETRO_MAME2010_DEF)
	$(CONFIGURE_NEOGEO_LIBRETRO_MAME078_DEF)
	$(CONFIGURE_NEOGEO_LIBRETRO_FBA_DEF)
	$(CONFIGURE_NEOGEO_LIBRETRO_IMAME4ALL_DEF)
	$(CONFIGURE_NEOGEO_LIBRETRO_END)
	$(CONFIGURE_NEOGEO_FBA2X_START)
	$(CONFIGURE_NEOGEO_FBA2X_FBA2X_DEF)
	$(CONFIGURE_NEOGEO_FBA2X_END)
	$(CONFIGURE_MAIN_NEOGEO_END)
endef

$(eval $(generic-package))
