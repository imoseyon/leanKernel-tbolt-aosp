CPU_JOB_NUM=2
TOOLCHAIN=/root/CodeSourcery/Sourcery_G++_Lite/bin/
TOOLCHAIN_PREFIX=arm-none-linux-gnueabi-

sed -i s/CONFIG_LOCALVERSION=\"-imoseyon-.*\"/CONFIG_LOCALVERSION=\"-imoseyon-${2}\"/ .config

if [ $1 -eq 2 ]; then
  sed -i "s/^.*UNLOCK_184.*$/CONFIG_UNLOCK_184MHZ=n/" .config
  zipfile="imoseyon_leanKernel_v$2.zip"
else
  sed -i "s/^.*UNLOCK_184.*$/CONFIG_UNLOCK_184MHZ=y/" .config
  zipfile="imoseyon_leanKernel_184Mhz_v$2.zip"
fi

make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN/$TOOLCHAIN_PREFIX

find . -name "*.ko" | xargs $TOOLCHAIN/${TOOLCHAIN_PREFIX}strip --strip-unneeded

cp drivers/net/wireless/bcm4329/bcm4329.ko ../zip/system/lib/modules
cp drivers/net/tun.ko ../zip/system/lib/modules
cp drivers/staging/zram/zram.ko ../zip/system/lib/modules
cp lib/lzo/lzo_decompress.ko ../zip/system/lib/modules
cp lib/lzo/lzo_compress.ko ../zip/system/lib/modules
cp fs/cifs/cifs.ko ../zip/system/lib/modules
cp arch/arm/boot/zImage ../mkboot/
cp drivers/net/wireless/bcm4329/bcm4329.ko ../mkboot/
cd ../mkboot
echo "making boot image"
./img.sh
echo "making zip file"
cp boot.img ../zip
cd ../zip
rm *.zip
zip -r $zipfile *
rm /tmp/*.zip
cp *.zip /tmp
