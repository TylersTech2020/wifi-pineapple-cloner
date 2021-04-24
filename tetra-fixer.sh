#!/bin/bash
# by DSR! from https://github.com/xchwarze/wifi-pineapple-cloner

printf "Based on Archer C7 hardware!\n"
printf "by DSR!\n\n"


printf "Device detection fix\n"

# Fix "unknown operand" error
sed -i 's/print $6/print $1/' files/etc/hotplug.d/block/20-sd
sed -i 's/print $6/print $1/' files/etc/hotplug.d/usb/30-sd
sed -i 's/print $6/print $1/' files/etc/init.d/pineapple
sed -i 's/print $6/print $1/' files/etc/rc.button/BTN_1
sed -i 's/print $6/print $1/' files/etc/rc.button/reset
sed -i 's/print $6/print $1/' files/etc/rc.d/S98pineapple
sed -i 's/print $6/print $1/' files/etc/rc.local
sed -i 's/print $6/print $1/' files/etc/uci-defaults/90-firewall.sh
sed -i 's/print $6/print $1/' files/etc/uci-defaults/91-fstab.sh
sed -i 's/print $6/print $1/' files/etc/uci-defaults/92-system.sh
sed -i 's/print $6/print $1/' files/etc/uci-defaults/95-network.sh
sed -i 's/print $6/print $1/' files/etc/uci-defaults/97-pineapple.sh
sed -i 's/print $6/print $1/' files/sbin/led

# Two scripts have TETRA because we have WAN port to play with.
sed -i 's/..Get Device/device="NANO"/' files/etc/rc.button/BTN_1
sed -i 's/..Get Device/device="NANO"/' files/etc/rc.button/reset
sed -i 's/..Get Device/device="NANO"/' files/etc/rc.local
sed -i 's/..Get Version and Device/device="TETRA"/' files/etc/uci-defaults/90-firewall.sh
sed -i 's/..Get Version and Device/device="NANO"/' files/etc/uci-defaults/91-fstab.sh
sed -i 's/..Get Version and Device/device="TETRA"/' files/etc/uci-defaults/95-network.sh
sed -i 's/..Get Version and Device/device="NANO"/' files/etc/uci-defaults/97-pineapple.sh

# Panel changes
sed -i 's/tetra/nulled/' files/pineapple/js/directives.js
sed -i 's/tetra/nulled/' files/pineapple/modules/ModuleManager/js/module.js
sed -i 's/nano/tetra/' files/pineapple/modules/Advanced/module.html
sed -i 's/nano/tetra/' files/pineapple/modules/ModuleManager/js/module.js
sed -i 's/nano/tetra/' files/pineapple/modules/Reporting/js/module.js
sed -i 's/nano/tetra/' files/pineapple/modules/Reporting/api/module.php
sed -i 's/unknown/tetra/' files/pineapple/api/pineapple.php
sed -i "s/cat \/proc\/cpuinfo | grep 'machine'/echo 'tetra'/" files/usr/bin/pineapple/site_survey


printf "Leds path fix\n"
sed -i 's/..led (C) Hak5 2018/device="NANO"/' files/sbin/led
sed -i 's/wifi-pineapple-nano:blue:system/tp-link:green:wps/' files/sbin/led
sed -i 's/wifi-pineapple-nano:blue:system/tp-link:green:wps/' files/etc/uci-defaults/97-pineapple.sh


printf "Pineapd fix\n"
cp fixs/tetra/pineapd files/usr/sbin/pineapd
cp fixs/tetra/pineap files/usr/bin/pineap
chmod +x files/usr/sbin/pineapd
chmod +x files/usr/bin/pineap


printf "Add Karma support\n"
mkdir -p files/lib/netifd/wireless
cp fixs/common/karma/mac80211.sh files/lib/netifd/wireless/mac80211.sh
cp fixs/common/karma/hostapd.sh files/lib/netifd/hostapd.sh
cp fixs/common/karma/hostapd_cli files/usr/sbin/hostapd_cli
cp fixs/common/karma/wpad files/usr/sbin/wpad
chmod +x files/lib/netifd/wireless/mac80211.sh
chmod +x files/lib/netifd/hostapd.sh
chmod +x files/usr/sbin/hostapd_cli
chmod +x files/usr/sbin/wpad


printf "Panel fixs\n"
# fix mobile view
cp fixs/panel/index.html files/pineapple/index.html
cp fixs/panel/css/main.css files/pineapple/css/main.css

# change notification timer (10 req vs 3 req)
sed -i 's/6000/20000/' files/pineapple/js/controllers.js

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


printf "Other fixs\n"
# fix default password: root
cp fixs/common/shadow files/etc/shadow

# fix pendrive hotplug
cp fixs/tetra/20-sd-tetra-fix files/etc/hotplug.d/block/20-sd-tetra-fix
rm files/etc/hotplug.d/block/20-sd
rm files/etc/hotplug.d/usb/30-sd

# system config
cp fixs/common/92-system.sh files/etc/uci-defaults/92-system.sh

# fix hardware name in banner
sed -i 's/DEVICE\/$device/DEVICE\/TETRA/' files/etc/uci-defaults/97-pineapple.sh


printf "\nDone!\n"
