getprop = $(shell cat module.prop | grep "^$(1)=" | head -n1 | cut -d'=' -f2)

MODNAME ?= $(call getprop,id)
MODVER ?= $(call getprop,version)
ZIP = $(MODNAME)-$(MODVER).zip

all: overlays $(ZIP)

magisk: $(ZIP)
	
overlays: clean_overlays
	overlays/gradlew -p overlays app\:assembleRelease
	while read -r package; do \
	    cp "overlays/app/build/outputs/apk/$$(echo $$package | sed 's/\./_/g')/release/app-$$(echo $$package | sed 's/\./_/g')-release.apk" "system/product/overlay/_$$package.InterFontOverlay.apk"; \
        done < overlays/overlays.txt

%.zip: clean_magisk
	zip -r9 $(ZIP) . -x $(MODNAME)-*.zip .gitignore .gitattributes Makefile /.git* *.DS_Store* *placeholder patch-font-names.sh /overlays* /screenshots*

push: all
	@ adb push $(ZIP) /data/local/tmp/interfontop.zip

install: push
	adb shell 'cd /data/local/tmp && su -c magisk --install-module interfontop.zip && rm interfontop.zip'

clean_magisk:
	@ rm -f *.zip

clean_overlays:
	@ rm -f system/product/overlay/*.apk
	overlays/gradlew -p overlays clean

clean: clean_magisk clean_overlays

