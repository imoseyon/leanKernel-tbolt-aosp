echo "making ramdisk"
./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
./mkbootimg --cmdline 'no_console_suspend=1 console=null' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img --base 0x05200000 
echo "copying files to /tmp"
cp boot.img /tmp
cp *.ko /tmp
