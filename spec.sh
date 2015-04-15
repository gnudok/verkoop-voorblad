#!/bin/bash
DISKSIZE=$(dmesg |grep '\bsd'|grep GB|cut -d'(' -f2|cut -d' ' -f1)
CPUSPEED=$(lscpu|grep MHz|cut -d' ' -f17)

cat > spec.tex <<EOF
\newcommand{\disksize}{$DISKSIZE}
\newcommand{\cpuspeed}{$CPUSPEED}
EOF
