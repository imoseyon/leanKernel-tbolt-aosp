CPU_JOB_NUM=2
TOOLCHAIN=/root/CodeSourcery/Sourcery_G++_Lite/bin/
TOOLCHAIN_PREFIX=arm-none-linux-gnueabi-

if [ $1 -eq 3 ]; then
  OPT=1
  sed -i /CONFIG_TUN/d .config
  sed -i /CONFIG_CIFS/d .config
  echo "### DO NOT CTRL-C ####"
else
  OPT=$1
fi

sed -i s/CONFIG_LOCALVERSION=\"-imoseyon-.*\"/CONFIG_LOCALVERSION=\"-imoseyon-${2}\"/ .config
#sed -i "s_define SLEVEL.*_define SLEVEL ${OPT}_" arch/arm/mach-msm/acpuclock-7x30.c
make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN/$TOOLCHAIN_PREFIX
if [ $1 -eq 3 ]; then
  sed -i /CONFIG_TUN/d .config
  sed -i /CONFIG_CIFS/d .config
fi
cp arch/arm/boot/zImage ../mkboot/
cp drivers/net/wireless/bcm4329/bcm4329.ko ../mkboot/
cd ../mkboot
echo "making boot image"
./img.sh

