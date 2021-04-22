#!/bin/bash
# by DSR! from https://github.com/xchwarze/wifi-pineapple-cloner

printf "Based on Archer C7 hardware!\n"
printf "by DSR!\n\n"

printf "Device detection fix\n"
# Two scripts have TETRA because we have WAN port to play with.
sed -i 's/..Get Version and Device/device="TETRA"/' files/etc/uci-defaults/90-firewall.sh
sed -i 's/..Get Version and Device/device="NANO"/' files/etc/uci-defaults/91-fstab.sh
sed -i 's/..Get Version and Device/device="TETRA"/' files/etc/uci-defaults/95-network.sh
sed -i 's/..Get Version and Device/device="NANO"/' files/etc/uci-defaults/97-pineapple.sh
sed -i 's/..Get Device/device="NANO"/' files/etc/rc.button/BTN_1
sed -i 's/..Get Device/device="NANO"/' files/etc/rc.button/reset
sed -i 's/..Get Device/device="NANO"/' files/etc/rc.local
sed -i 's/unknown/tetra/' files/pineapple/api/pineapple.php

printf "Leds path fix\n"
sed -i 's/..led (C) Hak5 2018/device="NANO"/' files/sbin/led
sed -i 's/wifi-pineapple-nano:blue:system/tp-link:green:wps/' files/sbin/led
sed -i 's/wifi-pineapple-nano:blue:system/tp-link:green:wps/' files/etc/uci-defaults/97-pineapple.sh

printf "Pineapd fix\n"
cp fixs/tetra/pineapd files/usr/sbin/pineapd
chmod +x files/usr/sbin/pineapd
cp fixs/tetra/pineap files/usr/bin/pineap
chmod +x files/usr/bin/pineap

printf "Other fixs\n"
# fix pendrive hotplug
cp fixs/tetra/20-sd-tetra-fix files/etc/hotplug.d/block/20-sd-tetra-fix
sed -i 's/DEVICE\/$device/DEVICE\/TETRA/' files/etc/uci-defaults/97-pineapple.sh

# fix mobile view
cp fixs/panel/index.html files/pineapple/index.html
cp fixs/panel/css/main.css files/pineapple/css/main.css

# fix png file size
cp fixs/panel/img/browser_chrome.png files/pineapple/img/browser_chrome.png
cp fixs/panel/img/browser_ff.png files/pineapple/img/browser_ff.png
cp fixs/panel/img/browser_ie.png files/pineapple/img/browser_ie.png
cp fixs/panel/img/browser_opera.png files/pineapple/img/browser_opera.png
cp fixs/panel/img/browser_safari.png files/pineapple/img/browser_safari.png
cp fixs/panel/img/logo.png files/pineapple/img/logo.png
cp fixs/panel/img/logout.png files/pineapple/img/logout.png
cp fixs/panel/img/notify.png files/pineapple/img/notify.png

# fix docs size
truncate -s 0 files/pineapple/modules/Setup/eula.txt
truncate -s 0 files/pineapple/modules/Setup/license.txt

printf "\nDone!\n"