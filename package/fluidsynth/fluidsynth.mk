################################################################################
#
# Fluidsynth
#
################################################################################

FLUIDSYNTH_VERSION = 1.1.6
FLUIDSYNTH_SITE = http://downloads.sourceforge.net/project/fluidsynth/fluidsynth-$(FLUIDSYNTH_VERSION)

FLUIDSYNTH_LICENSE = GPL2
FLUIDSYNTH_DEPENDENCIES =

$(eval $(cmake-package))
