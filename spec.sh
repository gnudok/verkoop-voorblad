#!/bin/bash
DISKSIZE=$(dmesg |grep '\bsd'|grep GB|cut -d'(' -f2|cut -d' ' -f1)
CPUSPEED=$(lscpu|grep MHz|cut -d' ' -f17)
CORECOUNT=$(lscpu|grep Core|cut -d' ' -f7)
MEMSIZE=$(free -m|grep Mem|cut -d' ' -f11)

cat > spec.tex <<EOF
\newcommand{\disksize}{$DISKSIZE}
\newcommand{\cpuspeed}{$CPUSPEED}
\newcommand{\corecount}{$CORECOUNT}
\newcommand{\memsize}{$MEMSIZE}
EOF
