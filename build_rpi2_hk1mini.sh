#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.3"
#BUILDER="https://downloads.openwrt.org/releases/22.03.3/targets/bcm27xx/bcm2709/openwrt-imagebuilder-22.03.3-bcm27xx-bcm2709.Linux-x86_64.tar.xz"
BUILDER="https://downloads.openwrt.org/releases/22.03.3/targets/bcm27xx/bcm2709/openwrt-imagebuilder-22.03.3-bcm27xx-bcm2709.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=128 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=4096 #Rootfs-Partitionsize in MB
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image  PROFILE="rpi-2" \
           PACKAGES="bash autocore-arm kmod-usb-net kmod-usb-net-asix kmod-usb-net-asix-ax88179 \
                     kmod-usb-net2280 kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas \
                     kmod-video-uvc kmod-ath kmod-ath9k-common kmod-ath9k-htc kmod-mac80211 \
                     kmod-rt2800-lib kmod-rt2800-usb kmod-rt2x00-lib kmod-rt2x00-usb ath9k-htc-firmware \
                     rt2800-usb-firmware gpioctl-sysfs gpiod-tools i2c-tools irqbalance \
                     luci-app-unblockneteasemusic luci-app-unblockmusic luci-app-upnp luci-app-usb-printer luci-app-uugamebooster \
                     luci-app-vnstat luci-app-watchcat luci-app-webadmin luci-app-wifischedule luci-app-wireguard luci-app-wrtbwmon luci-app-xlnetacc \
                     luci-app-zerotier luci-app-argon-config luci-theme-argonv3 luci-theme-bootstrap-mod luci-theme-bootstrap luci-theme-material luci-theme-Butterfly-dark \
                     luci-theme-Butterfly luci-theme-atmaterial luci-theme-darkmatter luci-theme-edge luci-theme-infinityfreedom luci-theme-neobird luci-theme-netgearv2 \
					 luci-theme-rosy luci-theme-openwrt-2020 luci-i18n-base-en luci-i18n-ssr-plus-en luci-i18n-ttyd-en luci-i18n-zerotier-en \
					 ariang webui-aria2 coremark ddns-scripts_cloudflare.com-v4 ddns-scripts_freedns_42_pl \
					 ddns-scripts_godaddy.com-v1 ddns-scripts_no-ip_com docker dockerd hostapd hostapd-common \
					 hostapd-utils iperf3 iw-full iwinf minieap bind-dig bind-host openssh-sftp-client openssh-sftp-server \
					 xl2tpd strongswan-default sstp-client vnstati wireless-tools wpa-cli wpa-supplicant \
					 ppp-mod-pptp openvpn-openssl openvpn-easy-rsa v2raya v2rayA wget-ssl \
					 ebtables-utils ebtables ip6tables-extra ip6tables-nft ip6tables-mod-nat ip6tables ip \
					 ipset ipset-dns ipset-lists iptables iptables-nft iptables-mod-conntrack-extra iptables-mod-extra \
					 iptables-mod-filter iptables-mod-hashlimit iptables-mod-ipopt iptables-mod-iprange iptables-mod-ipsec \
					 iptables-mod-nat-extra iptables-mod-tproxy jshn adb autocore-arm autocore-x86 bzip2 cups cups-client \
					 cups-ppdc e2fsprogs f2fs-tools f2fsck fdisk fstrim gzip htop libcap-bin libcups \
					 libcupsimage lsblk lscpu nano node-npm p7zip resize2fs screen snmpd tmate tmux tree tune2fs unzip usbutils \
					 vim-full xray-core xray-plugin zip zsh 3ginfo atinout comgt-ncm comgt iconv \
					 kmod-macvlan kmod-mii kmod-nls-base kmod-usb-acm kmod-usb-core kmod-usb-net kmod-usb-serial-option kmod-usb-serial-qualcomm \
					 kmod-usb-serial-wwan kmod-usb-serial libimobiledevice-utils libplist-utils libusbmuxd-utils luci-app-3ginfo-lite \
					 luci-app-atinout luci-app-mmconfig luci-app-modemband luci-app-modeminfo \
                     luci-app-sms-tool luci-app-smstools3 luci-proto-3g luci-proto-bonding luci-proto-modemmanager luci-proto-ncm luci-proto-openconnect luci-proto-qmi luci-proto-relay minicom modemmanager \
                     picocom qmi-utils qtools sms-tool smstools3 umbim uqmi usb-modeswitch usbmuxd git git-http \
                     coreutils coreutils-stdbuf jq ip-full kmod-tun openssh-client https-dns-proxy python3 httping \
                     stunnel stubby getdns badvpn corkscrew coreutils-timeout libudev-fbsd libudev-zero procps-ng procps-ng-ps \
                     python3-pip sshpass tc mactoiface luci-app-libernet luci-app-libernet-bin luci-app-libernet-plus \
                     luci-app-mikhmon luci-app-mikhmon4 luci-app-netmon luci-app-openspeedtest luci-app-shutdown luci-app-tinyfm \
                     luci-app-v2raya luci-app-xderm-bin luci-app-xderm luci-app-xderm-limit luci-app-freevpnsite luci-app-wegare xmm-modem php8-cli " \
            FILES="${BASEDIR}/files/" \
            BIN_DIR="${OUTPUT}"
