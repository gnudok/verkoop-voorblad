#!/bin/bash
DISKSIZE=$(dmesg |grep '\bsd'|grep GB|cut -d'(' -f2|cut -d' ' -f1)

cat > spec.tex <<EOF
\newcommand{\disksize}{$DISKSIZE}
EOF
