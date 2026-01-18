#!/bin/bash

rm -rf openwrt
rm -rf mtk-openwrt-feeds

git clone --branch openwrt-25.12 https://github.com/openwrt/openwrt.git openwrt || true
cd openwrt; git checkout b590b79a7797e571daa450e261033004183a2530; cd -;		#kernel: modules: add kmod-pmbus-sensors package

git clone --branch master https://git01.mediatek.com/openwrt/feeds/mtk-openwrt-feeds || true
cd mtk-openwrt-feeds; git checkout 13d0caab6da409cfbbe161401c54454e5a2ae220; cd -;	#[openwrt-24/openwrt-25.12][MAC80211][WiFi7][modify the sns script]

#\cp -r my_files/feed_revision mtk-openwrt-feeds/autobuild/unified/

#\cp -r my_files/w-defconfig mtk-openwrt-feeds/autobuild/unified/filogic/master/defconfig
\cp -r my_files/w-rules mtk-openwrt-feeds/autobuild/unified/filogic/rules

#\cp -r my_files/999-wozi-add-rtl8261be-support.patch openwrt/target/linux/mediatek/patches-6.12/

### tx_power patch - required for BE14 boards with defective eeprom flash
mkdir -p openwrt/package/kernel/mt76/patches && cp -r my_files/99999_tx_power_check.patch $_

cd openwrt
bash ../mtk-openwrt-feeds/autobuild/unified/autobuild.sh filogic-mac80211-mt798x_rfb-wifi7_nic log_file=make

exit 0

cd openwrt
\cp -r ../my_files/w-filogic.mk target/linux/mediatek/image/filogic.mk
#\cp -r ../configs/mtk_test.nocrypto.config openwrt/.config
\cp -r ../configs/mtk_test.crypto.config openwrt/.config
make menuconfig
make -j$(nproc) V=s

exit 0

./scripts/feeds update -a
./scripts/feeds install -a


make menuconfig
make -j24 V=sc
