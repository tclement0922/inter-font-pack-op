#!/system/bin/sh

MODPATH="/data/adb/modules/inter-font-op"

sed 's/<\/familyset>//g' /system/etc/fonts.xml | cat - $MODPATH/fallback.xml > $MODPATH/system/etc/fonts.xml

sed 's/<\/familyset>//g' /system/etc/fonts_base.xml | cat - $MODPATH/fallback.xml > $MODPATH/system/etc/fonts_base.xml

