#!/bin/bash
DISKSIZE=$(dmesg |grep '\bsd'|grep GB|cut -d'(' -f2|cut -d' ' -f1)
CPUSPEED=$(lscpu|grep MHz|cut -d' ' -f17)
CORECOUNT=$(lscpu|grep Core|cut -d' ' -f7)
MEMSIZE=$(free -m|grep Mem|cut -d' ' -f11)
BITS64=$(if (lscpu|grep "CPU op-mode"|grep 64) &>  /dev/null ; then echo "Ja"; else echo "Nee"; fi)
WIRELESS="Nee"
ACCELLARATED="Nee"
HYPERTHREADING="Nee"
BURNER="DVD"

PPRICE=$(echo scale=2 \; \($CPUSPEED/3000\) \* 17|bc)
WIDTHPRICE=$(if [ $BITS64 = "Ja" ]; then echo scale=2 \; 0.5 \* $PPRICE|bc; else echo 0; fi)
MULTICOREPRICE=$(if [ $CORECOUNT = "2" ]; then echo scale=2 \; 0.5 \* $PPRICE |bc; else echo 0; fi)
HYPERTHREADINGPRICE=$(if [ $HYPERTHREADING = "Ja" ]; then echo scale=2 \; 0.5 \* $PPRICE|bc; else echo 0; fi)
WIRELESSPRICE=$(if [ $WIRELESS = "Ja" ]; then echo 5; else echo 0; fi)
ACCELLARATEDPRICE=$(if [ $ACCELLARATED = "Ja" ]; then echo 5; else echo 0; fi)
BURNERPRICE=$(if [ $BURNER = "DVD" ]; then echo 4; else echo 0; fi)
HDPRICE=$(echo scale=2 \; \($DISKSIZE/120\) \* 11|bc)
MEMPRICE=$(echo scale=2 \; \($MEMSIZE/512\) \* 6|bc)


PRICE=$(echo $PPRICE + $WIDTHPRICE + $MULTICOREPRICE + $HYPERTHREADINGPRICE + $WIRELESSPRICE + $ACCELLARATEDPRICE + $HDPRICE + $MEMPRICE + $BURNERPRICE|bc)

cat > spec.tex <<EOF
\newcommand{\disksize}{$DISKSIZE}
\newcommand{\cpuspeed}{$CPUSPEED}
\newcommand{\corecount}{$CORECOUNT}
\newcommand{\memsize}{$MEMSIZE}
\newcommand{\bitssixtyfour}{$BITS64}
\newcommand{\price}{$PRICE}
EOF

#echo $PPRICE
#echo $WIDTHPRICE
#echo $MULTICOREPRICE
#echo $HYPERTHREADINGPRICE
#echo $WIRELESSPRICE
#echo $ACCELLARATEDPRICE
#echo $HDPRICE
#echo $MEMPRICE
#echo $BURNERPRICE
