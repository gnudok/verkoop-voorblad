#!/bin/bash
DISKSIZE=$(dmesg |grep '\bsd'|grep GB|cut -d'(' -f2|cut -d' ' -f1)
CPUSPEED=$(lscpu|grep MHz|cut -d' ' -f17)
CORECOUNT=$(lscpu|grep Core|cut -d' ' -f7)
MEMSIZE=$(free -m|grep Mem|cut -d' ' -f11)
BITS64=$(if (lscpu|grep "CPU op-mode"|grep 64) &> /dev/null ; then echo "Ja"; else echo "Nee"; fi)

cat > spec.tex <<EOF
\newcommand{\disksize}{$DISKSIZE}
\newcommand{\cpuspeed}{$CPUSPEED}
\newcommand{\corecount}{$CORECOUNT}
\newcommand{\memsize}{$MEMSIZE}
\newcommand{\bitssixtyfour}{$BITS64}
EOF
