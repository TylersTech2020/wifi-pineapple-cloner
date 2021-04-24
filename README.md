# Universal Wifi pineapple hardware cloner

The Pineapple NANO and TETRA were excellent security hardware but in 2020 they reached their end of life.
So to give a new life to this platform in more modern hardware, I've made these scripts. 


## Build steps

1. Unpack firmware for get file system
```
# get fmk tool
$ git clone https://github.com/rampageX/firmware-mod-kit fmk-tool

# get target firmware (example pineapple nano)
$ wget https://www.wifipineapple.com/downloads/nano/latest -O nanofw.bin
$ fmk-tool/extract-firmware.sh nanofw.bin
$ sudo chown -R $USER fmk
$ mv fmk/rootfs rootfs-nano
$ rm -rf fmk
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
$ make image PROFILE=gl-ar150 PACKAGES="at autossh base-files block-mount ca-certificates chat dnsmasq e2fsprogs ethtool firewall getrandom hostapd-utils ip6tables iperf3 iptables iwinfo kmod-ath kmod-ath9k kmod-ath9k-htc kmod-crypto-aead kmod-crypto-crc32c kmod-crypto-manager kmod-eeprom-93cx6 kmod-fs-ext4 kmod-fs-nfs kmod-fs-vfat kmod-gpio-button-hotplug kmod-ip6tables kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload kmod-leds-gpio kmod-ledtrig-default-on kmod-ledtrig-netdev kmod-ledtrig-timer kmod-lib-crc-ccitt kmod-libphy kmod-mii kmod-mt76-core kmod-mt76-usb kmod-mt76x02-usb kmod-mt76x2-common kmod-mt76x2u kmod-nf-conntrack kmod-nf-conntrack6 kmod-nf-flow kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-nathelper kmod-nf-reject kmod-nf-reject6 kmod-ppp kmod-pppoe kmod-pppox kmod-rt2800-lib kmod-rt2800-usb kmod-rt2x00-lib kmod-rt2x00-usb kmod-rtl8187 kmod-rtl8192c-common kmod-rtl8192cu kmod-rtlwifi kmod-rtlwifi-usb kmod-scsi-core kmod-scsi-generic kmod-slhc kmod-usb-acm kmod-usb-core kmod-usb-ehci kmod-usb-net kmod-usb-net-asix kmod-usb-net-asix-ax88179 kmod-usb-net-cdc-ether kmod-usb-net-qmi-wwan kmod-usb-net-rndis kmod-usb-net-sierrawireless kmod-usb-net-smsc95xx kmod-usb-ohci kmod-usb-storage kmod-usb-storage-extras kmod-usb-uhci kmod-usb-wdm kmod-usb2 libbz2-1.0 libcurl4 libelf1 libffi libgmp10 libiconv-full2 libintl libiwinfo20181126 libltdl7 libmbedtls12 libncurses6 libnet-1.2.x libnl-core200 libnl-genl200 libnl-nf200 libnl-route200 libnl200 libopenssl-conf libopenssl1.1 libpcap1 libreadline8 libuclient20160123 libusb-1.0-0 libustream-mbedtls20150806 libxml2 logd macchanger mt7601u-firmware mtd nano ncat netcat nginx odhcp6c odhcpd-ipv6only openssh-client openssh-keygen openssh-server openssh-sftp-server openssl-util php7 php7-cgi php7-fpm php7-mod-hash php7-mod-json php7-mod-mbstring php7-mod-openssl php7-mod-session php7-mod-sockets php7-mod-sqlite3 ppp ppp-mod-pppoe procps-ng-pkill procps-ng-ps python-logging python-openssl python-sqlite3 rtl-sdr ssmtp tcpdump terminfo uboot-envtools uci uclibcxx uclient-fetch urandom-seed urngd usb-modeswitch usbreset usbutils wget wireless-tools wpad busybox libatomic1 -wpad-basic -dropbear" FILES=../files/
$ cp bin/targets/ar71xx/generic/openwrt-19.07.2-ar71xx-generic-gl-ar150-squashfs-sysupgrade.bin ../gl-ar150-pineapple-nano.bin
```

5. Flash the target hardware with this custom firmware!


## Important notes

1. The original pineapple binaries are compiled with mips24kc and BE endianness.
So your target hardware must support the instructionset with this endianness. [List of hardware](https://openwrt.org/docs/techref/instructionset/mips_24kc).

2. The original pineapple binaries are compiled with SSP ([Stack-Smashing Protection](https://openwrt.org/docs/guide-user/security/security-features)) 
Your version has to support it, so as not to have this type of errors:
```
[    7.383577] kmodloader: loading kernel modules from /etc/modules-boot.d/*
[    8.052737] crypto_hash: Unknown symbol __stack_chk_guard (err 0)
[    8.057461] crypto_hash: Unknown symbol __stack_chk_fail (err 0)
```

3. WiFi Pineapple use a modified version of: /lib/netifd/wireless/mac80211.sh /lib/netifd/hostapd.sh /lib/wifi/mac80211.sh
You may have to make yours based on these.

4. If you are stuck at the message "The WiFi Pineapple is still booting" don't panic, this is a known issue with running the WiFi Pineapple firmware on the AR150. All you have to do is ssh into the AR150 with the username root and password you set originally when you booted the AR150 right out of the box.
Executing the command jffs2reset -y && reboot should resolve your problems. 


## Recomended setup
1. GL-AR150 https://www.gl-inet.com/products/gl-ar150/
2. USB 2.0 2 ports hub https://www.ebay.co.uk/itm/USB-2-0-2-Dual-Port-Hub-For-Laptop-Macbook-Notebook-PC-Mouse-Flash-Disk/273070654192
2. Generic RT5370 adapter
3. Please support Hak5 work and buy the original hardware
