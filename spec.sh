#!/bin/bash
export LANG=en_US.UTF-8
DISKSIZE=$(dmesg |grep '\bsd'|grep GB|cut -d'(' -f2|cut -d' ' -f1)
if lscpu|grep "CPU max MHz"; then 
	CPUSPEED=$(lscpu|grep "CPU max MHz"|cut -d':' -f2)
else
	CPUSPEED=$(lscpu|grep MHz|cut -d' ' -f17)
fi
CPUSPEED=$(echo scale=0 \; $CPUSPEED/1|bc)
CORECOUNT=$(lscpu|grep Core|cut -d' ' -f7)
MEMSIZE=$(free -m|grep Mem|colrm 19|cut -d: -f2|sed 's/ //g')
BITS64=$(if (lscpu|grep "CPU op-mode"|grep 64) &>  /dev/null ; then echo "Ja"; else echo "Nee"; fi)
WIRELESS=$(if (iwconfig 2>&1|grep IEEE) &> /dev/null; then echo Ja; else echo Nee;fi)
ACCELLERATED=$(if (lsmod|grep -w nvidia) &> /dev/null || (lsmod|grep -w i915) &> /dev/null; then echo Ja; else echo Nee;fi)
HYPERTHREADING=$(if [ 2 = $(lscpu|grep Thread|cut -d' ' -f7) ]; then echo Ja ; else echo Nee; fi)
DRIVES=$(ls /dev/dvd* /dev/cd*) 
BURNER=$(if (echo $DRIVES|grep dvdrw) &> /dev/null ; then echo "DVD"; else if (echo $DRIVES|grep cdrw) &> /dev/null; then echo "CD"; else echo "Geen"; fi; fi)
HOSTNAME=$(hostname)
DEBIAN_VERSION=$(cat /etc/debian_version)
KERNEL_VERSION=$(uname -r)
CPUMODEL=$(grep "model name" /proc/cpuinfo |sort -u|cut -d: -f2|cut -d' ' -f2-)
GRAPHICS=$(lspci|grep -i vga|cut -d: -f3|cut -d'(' -f1|cut -d' ' -f2-)
GRAPHICS=$(echo $GRAPHICS|sed -e 's/Advanced Micro Devices, Inc.//')
GRAPHICS=$(echo $GRAPHICS|sed -e 's/Intel Corporation/Intel/')
if [[ "$DEBIAN_VERSION" =~ ^8.* ]]; then
	DEBIAN_CODE="Jessie";
else
	DEBIAN_CODE="Wheezy";
fi
MACADDR=$(ifconfig eth0|grep HWaddr|colrm 1 38)
IPADDR=$(echo $(ifconfig eth0|grep "inet addr")|cut -d' ' -f2|cut -d: -f2)
if lsblk|grep crypt; then 
	DISK_ENCRYPTION=gnu
else
	DISK_ENCRYPTION=Geen
fi


PPRICE=$(echo scale=2 \; \($CPUSPEED/3000\) \* 17|bc)
WIDTHPRICE=$(if [ $BITS64 = "Ja" ]; then echo scale=2 \; 0.5 \* $PPRICE|bc; else echo 0; fi)
MULTICOREPRICE=$(if [ $CORECOUNT = "2" ]; then echo scale=2 \; 0.5 \* $PPRICE |bc; else echo 0; fi)
HYPERTHREADINGPRICE=$(if [ $HYPERTHREADING = "Ja" ]; then echo scale=2 \; 0.5 \* $PPRICE|bc; else echo 0; fi)
WIRELESSPRICE=$(if [ $WIRELESS = "Ja" ]; then echo 5; else echo 0; fi)
ACCELLERATEDPRICE=$(if [ $ACCELLERATED = "Ja" ]; then echo 5; else echo 0; fi)
BURNERPRICE=$(if [ $BURNER = "DVD" ]; then echo 4; else echo 0; fi)
HDPRICE=$(echo scale=2 \; \($DISKSIZE/120\) \* 11|bc)
MEMPRICE=$(echo scale=2 \; \($MEMSIZE/512\) \* 6|bc)


PRICE=$(echo $PPRICE + $WIDTHPRICE + $MULTICOREPRICE + $HYPERTHREADINGPRICE + $WIRELESSPRICE + $ACCELLERATEDPRICE + $HDPRICE + $MEMPRICE + $BURNERPRICE|bc)

if laptop-detect; then
	PRICE=$(echo $PRICE \* 1.20|bc)
fi

cat > spec.tex <<EOF
\newcommand{\disksize}{$DISKSIZE}
\newcommand{\cpuspeed}{$CPUSPEED}
\newcommand{\corecount}{$CORECOUNT}
\newcommand{\memsize}{$MEMSIZE}
\newcommand{\bitssixtyfour}{$BITS64}
\newcommand{\burner}{$BURNER}
\newcommand{\price}{$PRICE}
\newcommand{\wireless}{$WIRELESS}
\newcommand{\debianversion}{$DEBIAN_VERSION}
\newcommand{\debiancode}{$DEBIAN_CODE}
\newcommand{\kernelversion}{$KERNEL_VERSION}
\newcommand{\accelerated}{$ACCELLERATED}
\newcommand{\hyperthreading}{$HYPERTHREADING}
\newcommand{\cpumodel}{$CPUMODEL}
\newcommand{\graphics}{$GRAPHICS}
\newcommand{\hostname}{$HOSTNAME}
\newcommand{\macaddr}{$MACADDR}
\newcommand{\ipaddr}{$IPADDR}
\newcommand{\diskpassword}{$DISK_ENCRYPTION}
EOF

echo Processor price: $PPRICE
echo 64 bit price: $WIDTHPRICE
echo Cores price: $MULTICOREPRICE
echo Hyperthreading price: $HYPERTHREADINGPRICE
echo Wireless price: $WIRELESSPRICE
echo Accelarated price: $ACCELLERATEDPRICE
echo HDPrice: $HDPRICE
echo MemSize: $MEMSIZE Memprice: $MEMPRICE
echo Burnerprice: $BURNERPRICE

echo
echo Total: $PRICE
