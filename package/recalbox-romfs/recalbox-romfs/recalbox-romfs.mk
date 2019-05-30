################################################################################
#
# recalbox-romfs
#
################################################################################

RECALBOX_ROMFS_SOURCE =
RECALBOX_ROMFS_SITE =
RECALBOX_ROMFS_INSTALL_STAGING = NO

ES_SYSTEMS = $(@D)/es_systems.cfg
ES_SYSTEMS_TMP = $(ES_SYSTEMS).tmp
TARGET_ES_SYSTEMS_DIR = $(TARGET_DIR)/recalbox/share_init/system/.emulationstation
TARGET_ROMDIR = $(TARGET_DIR)/recalbox/share_init/

CONFIGGEN_STD_CMD = python /usr/lib/python2.7/site-packages/configgen/emulatorlauncher.pyc %CONTROLLERSCONFIG% -system %SYSTEM% -rom %ROM% -emulator %EMULATOR% -core %CORE% -ratio %RATIO% %NETPLAY%

# Each emulator must define :
#  - its es_systems.cfg entry
#  - its source roms folder
# You MUST add an empty line at the end of the define otherwise some commands
# will overlap and fail

# function to add the new system
# $1 = XML file
# $2 = full system name
# $3 = short system name
# $4 = e=list of extensions ex : .zip .ZIP
# $5 = platform
# $6 = theme
# $7 = extra configgen command line args
define RECALBOX_ROMFS_CALL_ADD_SYSTEM
    echo -e '<system>\n' \
    '<fullname>$(2)</fullname>\n' \
    "<name>$(3)</name>\n" \
    '<path>/recalbox/share/roms/$(3)</path>\n' \
    '<extension>$(4)</extension>\n' \
    "<command>$(CONFIGGEN_STD_CMD)$(7)</command>\n" \
    '<platform>$(5)</platform>\n' \
    '<theme>$(6)</theme>\n' \
    '<emulators>' > $(1)
endef

# function to add the emulator part of a XML
# $1 = XML file
# $2 = emulator name name
RECALBOX_ROMFS_CALL_START_EMULATOR = echo -e '<emulator name="$(2)">\n<cores>' >> $(1)

# function to add the core part of a XML
# $1 = XML file
# $2 = core name
RECALBOX_ROMFS_CALL_ADD_CORE = echo -e '<core>$(2)</core>' >> $(1)

# function to close the emulator part of a XML
# $1 = XML file
RECALBOX_ROMFS_CALL_END_EMULATOR = echo -e '</cores>\n</emulator>' >> $(1)

# function to add a standlone emulator part of a XML
# $1 = XML file
# $2 = emulator name name
RECALBOX_ROMFS_CALL_STANDALONE_EMULATOR = echo -e '<emulator name="$(2)"/>' >> $(1)

# function to add the new system
# $1 = XML file
# $2 = system rom source dir
# $3 = system rom destination dir
define RECALBOX_ROMFS_CALL_END_SYSTEM
    echo -e '</emulators>\n</system>' >> $(1)
    cp -R $(2) $(3)
endef

# function to add a new system that only has a standalone emulator
# $1 = XML file
# $2 = full system name
# $3 = short system name
# $4 = e=list of extensions ex : .zip .ZIP
# $5 = platform
# $6 = theme
# $7 = system rom source dir
# $8 = system rom destination dir
# $9 = extra configgen command line args
RECALBOX_ROMFS_CALL_ADD_STANDALONE_SYSTEM = $(call RECALBOX_ROMFS_CALL_ADD_STANDALONE_SYSTEM_FULLPATH,$(1),$(2),$(3),$(4),$(5),$(6),$(7),$(8),/recalbox/share/roms/$(3),$(9))

# function to add a new system that only has a standalone emulator specifying
# its full path to the roms folder
# $1 = XML file
# $2 = full system name
# $3 = short system name
# $4 = e=list of extensions ex : .zip .ZIP
# $5 = platform
# $6 = theme
# $7 = system rom source dir
# $8 = system rom destination dir
# $9 = full path to roms
# $10 = extra configgen command line args
define RECALBOX_ROMFS_CALL_ADD_STANDALONE_SYSTEM_FULLPATH
    echo -e '<system>\n' \
    '<fullname>$(2)</fullname>\n' \
    "<name>$(3)</name>\n" \
    '<path>$(9)</path>\n' \
    '<extension>$(4)</extension>\n' \
    "<command>$(CONFIGGEN_STD_CMD)$(10)</command>\n" \
    '<platform>$(5)</platform>\n' \
    '<theme>$(6)</theme>\n' \
    '<emulators />\n' \
    '</system>' >> $(1)
    cp -R $(7) $(8)
endef

# Init the es_systems.cfg
# Keep the empty line as there are several commands to chain at configure
define RECALBOX_ROMFS_ES_SYSTEMS
	echo '<?xml version="1.0"?>' > $(ES_SYSTEMS_TMP)
	echo '<systemList>' >>  $(ES_SYSTEMS_TMP)
	cat $(@D)/../recalbox-romfs-*/*.xml >> $(ES_SYSTEMS_TMP)
	echo -e '<system>\n' \
		"\t<fullname>Favorites</fullname>\n" \
		'\t<name>favorites</name>\n' \
		"\t<command>$(CONFIGGEN_STD_CMD)</command>\n" \
		"\t<theme>favorites</theme>\n" \
	"</system>\n" \
	'</systemList>' >>  $(ES_SYSTEMS_TMP)
	xmllint --format $(ES_SYSTEMS_TMP) > $(ES_SYSTEMS)

endef
RECALBOX_ROMFS_CONFIGURE_CMDS += $(RECALBOX_ROMFS_ES_SYSTEMS)

# Copy rom dirs
define RECALBOX_ROMFS_ROM_DIRS
	cp -R $(@D)/../recalbox-romfs-*/roms $(@D)

endef
RECALBOX_ROMFS_CONFIGURE_CMDS += $(RECALBOX_ROMFS_ROM_DIRS)

# Copy from build to target
define RECALBOX_ROMFS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_ROMDIR)/roms
	mkdir -p $(TARGET_ES_SYSTEMS_DIR)
	$(INSTALL) -D -m 0644 $(ES_SYSTEMS) $(TARGET_ES_SYSTEMS_DIR)
	cp -r $(@D)/roms $(TARGET_ROMDIR)
endef

# Add necessary dependencies
# System: amiga600
ifeq ($(BR2_PACKAGE_AMIBERRY),y)
 	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-amiga600
endif
 	
# System: amiga1200
ifeq ($(BR2_PACKAGE_AMIBERRY),y)
 	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-amiga1200
endif

# System: amigacd32
ifeq ($(BR2_PACKAGE_AMIBERRY),y)
    RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-amigacd32
endif

# System: amigacdtv
#ifeq ($(BR2_PACKAGE_AMIBERRY),y)
#    RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-amigacdtv
#endif
 	
# System: amstradcpc
ifneq ($(BR2_PACKAGE_LIBRETRO_CAP32)$(BR2_PACKAGE_LIBRETRO_CROCODS),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-amstradcpc
endif

# System: apple2
ifeq ($(BR2_PACKAGE_LINAPPLE_PIE),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-apple2
endif

# System: atari2600
ifneq ($(BR2_PACKAGE_LIBRETRO_STELLA),)
    RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-atari2600
endif

# System: atari7800
ifneq ($(BR2_PACKAGE_LIBRETRO_PROSYSTEM),)
    RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-atari7800
endif

# System: atarist
ifneq ($(BR2_PACKAGE_LIBRETRO_HATARI),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-atarist
endif

# System: c64
ifneq ($(BR2_PACKAGE_LIBRETRO_VICE),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-c64
endif

# System: cavestory
ifneq ($(BR2_PACKAGE_LIBRETRO_NXENGINE),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-cavestory
endif

# System: channelf
ifneq ($(BR2_PACKAGE_LIBRETRO_FREECHAF),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-channelf
endif

# System: colecovision
ifneq ($(BR2_PACKAGE_LIBRETRO_BLUEMSX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-colecovision
endif

# System: daphne
ifeq ($(BR2_PACKAGE_HYPSEUS),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-daphne
endif

# System: dos
ifeq ($(BR2_PACKAGE_DOSBOX),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-dos
endif

# Sytem: dreamcast
ifeq ($(BR2_PACKAGE_REICAST),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-dreamcast
endif
ifeq ($(BR2_PACKAGE_REICAST_OLD),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-dreamcast
endif

# System: fba
ifneq ($(BR2_PACKAGE_PIFBA),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-fba
endif

# System: fba_libretro
ifneq ($(BR2_PACKAGE_LIBRETRO_FBNEO),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-fba_libretro
endif

# System: fds
ifneq ($(BR2_PACKAGE_LIBRETRO_FCEUMM)$(BR2_PACKAGE_LIBRETRO_NESTOPIA),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-fds
endif

# System: gamecube
ifeq ($(BR2_PACKAGE_DOLPHIN_EMU),y)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gamecube
endif

# System: gamegear
ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX)$(BR2_PACKAGE_LIBRETRO_GEARSYSTEM),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gamegear
endif

# System: gb
ifneq ($(BR2_PACKAGE_LIBRETRO_GAMBATTE)$(BR2_PACKAGE_LIBRETRO_TGBDUAL)$(BR2_PACKAGE_LIBRETRO_MGBA)$(BR2_PACKAGE_LIBRETRO_SAMEBOY),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gb
endif

# System: gba
ifneq ($(BR2_PACKAGE_LIBRETRO_GPSP)$(BR2_PACKAGE_LIBRETRO_MGBA)$(BR2_PACKAGE_LIBRETRO_METEOR),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gba
endif

# System: gbc
ifneq ($(BR2_PACKAGE_LIBRETRO_GAMBATTE)$(BR2_PACKAGE_LIBRETRO_TGBDUAL)$(BR2_PACKAGE_LIBRETRO_MGBA)$(BR2_PACKAGE_LIBRETRO_SAMEBOY),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gbc
endif

# System: gw
ifneq ($(BR2_PACKAGE_LIBRETRO_GW),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gw
endif

# System: gx4000
ifneq ($(BR2_PACKAGE_LIBRETRO_CAP32),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-gx4000
endif

# System: jaguar
ifneq ($(BR2_PACKAGE_LIBRETRO_VIRTUALJAGUAR),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-jaguar
endif

# System: lutro
ifneq ($(BR2_PACKAGE_LIBRETRO_LUTRO),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-lutro
endif

# System: lynx
ifneq ($(BR2_PACKAGE_LIBRETRO_HANDY)$(BR2_PACKAGE_LIBRETRO_BEETLE_LYNX),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-lynx
endif

# System: macintosh
ifneq ($(BR2_PACKAGE_LIBRETRO_MINIVMAC),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-macintosh
endif

# System: mame
ifneq ($(BR2_PACKAGE_LIBRETRO_MAME2003)$(BR2_PACKAGE_LIBRETRO_MAME2000)$(BR2_PACKAGE_ADVANCEMAME)$(BR2_PACKAGE_LIBRETRO_MAME2010)$(BR2_PACKAGE_LIBRETRO_MAME2015)$(BR2_PACKAGE_LIBRETRO_MAME2016)$(BR2_PACKAGE_LIBRETRO_MAME2003_PLUS),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-mame
endif

# System: mastersystem
ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX)$(BR2_PACKAGE_LIBRETRO_PICODRIVE)$(BR2_PACKAGE_LIBRETRO_GEARSYSTEM),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-mastersystem
endif

# System: megadrive
ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX)$(BR2_PACKAGE_LIBRETRO_PICODRIVE),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-megadrive
endif

# System: moonlight
ifeq ($(BR2_PACKAGE_MOONLIGHT_EMBEDDED),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-moonlight
endif

# System: msx
ifneq ($(BR2_PACKAGE_LIBRETRO_FMSX)$(BR2_PACKAGE_LIBRETRO_BLUEMSX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-msx
endif

# System: msx1
ifneq ($(BR2_PACKAGE_LIBRETRO_FMSX)$(BR2_PACKAGE_LIBRETRO_BLUEMSX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-msx1
endif

# System: msx2
ifneq ($(BR2_PACKAGE_LIBRETRO_FMSX)$(BR2_PACKAGE_LIBRETRO_BLUEMSX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-msx2
endif

# System: n64
ifneq ($(BR2_PACKAGE_MUPEN64PLUS_GLIDEN64)$(BR2_PACKAGE_MUPEN64PLUS_GLES2)$(BR2_PACKAGE_MUPEN64PLUS_GLES2RICE)$(BR2_PACKAGE_MUPEN64PLUS_VIDEO_GLIDE64MK2)$(BR2_PACKAGE_LIBRETRO_GLUPEN64),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-n64
endif

# System: nds
ifneq ($(BR2_PACKAGE_LIBRETRO_DESMUME)$(BR2_PACKAGE_LIBRETRO_MELONDS),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-nds
endif

# System: neogeo
ifneq ($(BR2_PACKAGE_LIBRETRO_MAME2003)$(BR2_PACKAGE_LIBRETRO_MAME2000)$(BR2_PACKAGE_LIBRETRO_FBNEO)$(BR2_PACKAGE_PIFBA)$(BR2_PACKAGE_LIBRETRO_MAME2010)$(BR2_PACKAGE_LIBRETRO_MAME2015)$(BR2_PACKAGE_LIBRETRO_MAME2016),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-neogeo
endif

# System: neogeocd
ifneq ($(BR2_PACKAGE_LIBRETRO_FBNEO),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-neogeocd
endif

# System: nes
ifneq ($(BR2_PACKAGE_LIBRETRO_FCEUMM)$(BR2_PACKAGE_LIBRETRO_FCEUNEXT)$(BR2_PACKAGE_LIBRETRO_NESTOPIA)$(BR2_PACKAGE_LIBRETRO_QUICKNES),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-nes
endif

# System: ngp
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_NGP),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-ngp
endif

# System: ngpc
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_NGP),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-ngpc
endif

# System: o2em
ifneq ($(BR2_PACKAGE_LIBRETRO_O2EM),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-o2em
endif

# System: oricatmos
ifneq ($(BR2_PACKAGE_ORICUTRON),)
		RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-oricatmos
endif

# System: pcengine
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_SUPERGRAFX)$(BR2_PACKAGE_LIBRETRO_BEETLE_PCE_FAST),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-pcengine
endif

# System: pcenginecd
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_SUPERGRAFX)$(BR2_PACKAGE_LIBRETRO_BEETLE_PCE_FAST),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-pcenginecd
endif

# System: pcfx
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_PCFX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-pcfx
endif

# System: pc98
ifneq ($(BR2_PACKAGE_LIBRETRO_NP2KAI),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-pc98
endif

# System: supergrafx
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_SUPERGRAFX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-supergrafx
endif

# System: psp
ifeq ($(BR2_PACKAGE_PPSSPP),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-psp
endif

# System: psx
ifneq ($(BR2_PACKAGE_LIBRETRO_PCSX_REARMED)$(BR2_PACKAGE_LIBRETRO_BEETLE_PSX)$(BR2_PACKAGE_LIBRETRO_BEETLE_PSX_HW),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-psx
endif

# System: prboom
ifneq ($(BR2_PACKAGE_LIBRETRO_PRBOOM),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-prboom
endif

# System: scummvm
ifeq ($(BR2_PACKAGE_SCUMMVM),y)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-scummvm
endif

# System: sega32x
ifneq ($(BR2_PACKAGE_LIBRETRO_PICODRIVE),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-sega32x
endif

# System: segacd
ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX)$(BR2_PACKAGE_LIBRETRO_PICODRIVE),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-segacd
endif

# System: sg1000
ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-sg1000
endif

# System: snes
ifneq ($(BR2_PACKAGE_LIBRETRO_SNES9X2002)$(BR2_PACKAGE_LIBRETRO_SNES9X2005)$(BR2_PACKAGE_LIBRETRO_SNES9X2010)$(BR2_PACKAGE_LIBRETRO_SNES9X),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-snes
endif

# System: samcoupe
ifeq ($(BR2_PACKAGE_SIMCOUPE),y)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-samcoupe
endif

# System: satellaview
ifneq ($(BR2_PACKAGE_LIBRETRO_SNES9X),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-satellaview
endif

# System: spectravideo
ifneq ($(BR2_PACKAGE_LIBRETRO_BLUEMSX),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-spectravideo
endif

# System: sufami
ifneq ($(BR2_PACKAGE_LIBRETRO_SNES9X),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-sufami
endif

# System: thomson
ifneq ($(BR2_PACKAGE_LIBRETRO_THEODORE),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-thomson
endif

# System: vectrex
ifneq ($(BR2_PACKAGE_LIBRETRO_VECX),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-vectrex
endif

# System: virtualboy
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_VB),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-virtualboy
endif

# System: wii
ifeq ($(BR2_PACKAGE_DOLPHIN_EMU),y)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-wii
endif

# System: wswan
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_WSWAN),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-wswan
endif

# System: wswanc
ifneq ($(BR2_PACKAGE_LIBRETRO_BEETLE_WSWAN),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-wswanc
endif

# System: x68000
ifneq ($(BR2_PACKAGE_LIBRETRO_PX68K),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-x68000
endif

# System: zx81
ifneq ($(BR2_PACKAGE_LIBRETRO_81),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-zx81
endif

# System: zxspectrum
ifneq ($(BR2_PACKAGE_LIBRETRO_FUSE),)
        RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-zxspectrum
endif

# System: 3do
ifneq ($(BR2_PACKAGE_LIBRETRO_4DO),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-3do
endif

# System: atari800
ifneq ($(BR2_PACKAGE_LIBRETRO_ATARI800),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-atari800
endif

# System: atari5200
ifneq ($(BR2_PACKAGE_LIBRETRO_ATARI800),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-atari5200
endif

# System: pokemini
ifneq ($(BR2_PACKAGE_LIBRETRO_POKEMINI),)
	RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-pokemini
endif

# System: uzebox
ifneq ($(BR2_PACKAGE_LIBRETRO_UZEM),)
    RECALBOX_ROMFS_DEPENDENCIES += recalbox-romfs-uzebox
endif

$(eval $(generic-package))
