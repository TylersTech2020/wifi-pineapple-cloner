# Universal Wifi pineapple hardware cloner

The Pineapple NANO and TETRA were excellent security hardware that in 2020 reached the end of its life. So to give a new life to this platform in more modern hardware i made these scripts. 


## Build steps

1. Unpack firmware for get file system
```
# get fmk tool
$ git clone https://github.com/rampageX/firmware-mod-kit fmk-tool

# get target firmware (example pineapple nano)
$ wget https://www.wifipineapple.com/downloads/nano/latest -O nanofw.bin
$ fmk-tool/extract-firmware.sh nanofw.bin
$ sudo chown "$USER":"$USER" fmk
$ cp -r fmk/rootfs rootfs-nano
```

2. Get opkg packages from openwrt file system
```
# get opkg status file
$ cp rootfs-nano/usr/lib/opkg/status status

# get packages
$ php opkg_statusdb_parser.php
```

3. Generate openwrt extra files
```
# copy pineapple files
$ chmod +x copier.sh
$ ./copier.sh

# fix files
$ chmod +x nano-fixer.sh
$ ./nano-fixer.sh
```

4. Build your custom build
```
# for this poc use openwrt imagebuilder v19.07.2 for ar71xx
$ wget https://downloads.openwrt.org/releases/19.07.2/targets/ar71xx/generic/openwrt-imagebuilder-19.07.2-ar71xx-generic.Linux-x86_64.tar.xz
$ tar xJf openwrt-imagebuilder-19.07.2-ar71xx-generic.Linux-x86_64.tar.xz
$ cd openwrt-imagebuilder-19.07.2-ar71xx-generic.Linux-x86_64

# based on step 2 data!
$ make image PROFILE=gl-ar150 PACKAGES="procps-ng-pkill kmod-usb-storage terminfo iwinfo openssh-sftp-server php7-mod-openssl libbz2-1.0 kmod-usb-net-asix-ax88179 wget kmod-usb-core kmod-crypto-manager kmod-usb-net-qmi-wwan chat kmod-rtl8187 kmod-nf-reject6 nano kmod-crypto-aead kmod-usb-wdm kmod-rt2800-usb openssl-util kmod-nf-flow kmod-lib-crc-ccitt kmod-rtlwifi kmod-mt76-usb getrandom openssh-server ssmtp libusb-1.0-0 kmod-nf-nathelper kmod-pppoe kmod-rt2x00-usb libiconv-full2 procps-ng-ps kmod-pppox kmod-ipt-conntrack kmod-nf-reject base-files kmod-nf-nat php7-cgi kmod-crypto-crc32c macchanger kmod-rt2800-lib php7-mod-sockets php7-mod-hash libnl-route200 autossh uboot-envtools kmod-usb-ohci kmod-mii dnsmasq libuclient20160123 usbutils libnl200 kmod-rt2x00-lib hostapd-utils libelf1 kmod-usb-ehci libintl libiwinfo20181126 kmod-usb-net-rndis libmbedtls12 block-mount kmod-fs-vfat kmod-usb2 firewall libxml2 kmod-nf-ipt kmod-rtlwifi-usb kmod-usb-net-sierrawireless tcpdump php7-mod-mbstring kmod-ip6tables odhcp6c uclient-fetch kmod-ath9k ethtool uci kmod-fs-ext4 kmod-mt76x2-common kmod-ledtrig-timer php7-mod-json kmod-usb-net-asix libgmp10 mtd odhcpd-ipv6only wpad usb-modeswitch php7-mod-session urandom-seed libffi ppp kmod-leds-gpio kmod-gpio-button-hotplug logd rtl-sdr libreadline8 kmod-usb-net kmod-usb-net-smsc95xx kmod-rtl8192c-common libopenssl1.1 openssh-keygen python-sqlite3 kmod-rtl8192cu uclibcxx iptables kmod-mt76x02-usb libnl-core200 kmod-libphy kmod-mt76x2u kmod-ipt-core e2fsprogs kmod-ledtrig-default-on kmod-usb-acm ca-certificates kmod-ppp libopenssl-conf php7-fpm libncurses6 netcat libpcap1 python-openssl kmod-nf-conntrack php7 libcurl4 kmod-fs-nfs ip6tables kmod-nf-ipt6 mt7601u-firmware at python-logging ncat kmod-nf-conntrack6 kmod-scsi-generic kmod-usb-uhci kmod-ath kmod-mt76-core kmod-ath9k-htc openssh-client usbreset libltdl7 php7-mod-sqlite3 kmod-usb-storage-extras libnl-nf200 iperf3 kmod-eeprom-93cx6 wireless-tools kmod-ipt-offload kmod-usb-net-cdc-ether kmod-scsi-core urngd kmod-slhc libnet-1.2.x nginx libustream-mbedtls20150806 ppp-mod-pppoe kmod-ipt-nat libnl-genl200 kmod-ledtrig-netdev busybox libatomic1 -wpad-basic -dropbear" FILES=../files/
cp bin/targets/ar71xx/generic/openwrt-19.07.2-ar71xx-generic-gl-ar150-squashfs-sysupgrade.bin ../gl-ar150-pineapple-nano.bin
```

5. Flash the target hardware with this custom firmware!


## Important notes

1. The original pineapple binaries are compiled with mips24kc and BE endianness.
So your target hardware must be support instructionset mips24kc with BE endianness. [List of hardware](https://openwrt.org/docs/techref/instructionset/mips_24kc).

2. The original pineapple binaries are compiled with SSP ([Stack-Smashing Protection](https://openwrt.org/docs/guide-user/security/security-features)) 
So your version has to support it so as not to have this type of errors:
```
[    7.383577] kmodloader: loading kernel modules from /etc/modules-boot.d/*
[    8.052737] crypto_hash: Unknown symbol __stack_chk_guard (err 0)
[    8.057461] crypto_hash: Unknown symbol __stack_chk_fail (err 0)
```

3. WiFi Pineapple use a modified version of: /lib/netifd/wireless/mac80211.sh /lib/netifd/hostapd.sh /lib/wifi/mac80211.sh
So you may have to make yours based on these.

4. If you are stuck at the message "The WiFi Pineapple is still booting" don't panic, this is a known issue with running the WiFi Pineapple firmware on the AR150. All you have to do is ssh into the AR150 with the username root and password you set originally when you booted the AR150 right out of the box.
Executing the command jffs2reset -y && reboot should resolve your problems. 


## Recomended setup
1. GL-AR150 https://www.gl-inet.com/products/gl-ar150/
2. USB 2.0 2 ports hub https://www.ebay.co.uk/itm/USB-2-0-2-Dual-Port-Hub-For-Laptop-Macbook-Notebook-PC-Mouse-Flash-Disk/273070654192
2. Generic RT5370 adapter
3. Please support Hak5 work and buy the original hardware
