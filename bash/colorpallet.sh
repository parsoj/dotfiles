#!/bin/bash
# Original: http://frexx.de/xterm-256-notes/
#           http://frexx.de/xterm-256-notes/data/colortable16.sh
# Modified by Aaron Griffin
# and further by Kazuo Teramoto
FGNAMES=('c_8 ' '  c_9  ' ' c10 ' ' c11' '  c12 ' ' c13 ' '  c14 ' ' c15 ')
BGNAMES=('DFT ' 'c_0 ' 'c_1 ' 'c_2 ' 'c_3 ' 'c_4 ' 'c_5 ' 'c_6 ' 'c_7 ')

for b in {0..8}; do
  ((b>0)) && bg=$((b+39))

  echo -en "\033[0m ${BGNAMES[b]} "
  
  for f in {0..7}; do
    echo -en "\033[${bg}m\033[$((f+30))m ${FGNAMES[f]} "
  done
  
  echo -en "\033[0m "
  echo -en "\033[0m\n\033[0m      "
  
  for f in {0..7}; do
    echo -en "\033[${bg}m\033[1;$((f+30))m ${FGNAMES[f]} "
  done

  echo -en "\033[0m "
  echo -e "\033[0m"

  echo "                                                                                 "
done
