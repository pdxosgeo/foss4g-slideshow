#!/bin/sh

PATH="/usr/bin:/usr/local/bin"

MAP="in/$1"
BAR="bar.png"
QR="qr.png"
OUT="out/$1"
TEXTCOLOR="white"
FONT="Arvo.ttf"
POINT=42
BLUR=20

#
# composite blur under bar
#
MAP_HEIGHT=$( identify $MAP | awk '{ print $3 }' | awk -F 'x' '{ print $2 }' )
BAR_HEIGHT=$( identify $BAR | awk '{ print $3 }' | awk -F 'x' '{ print $2 }' )
let "BY = $MAP_HEIGHT - $BAR_HEIGHT"
convert $MAP -crop +0+$BY $OUT
mogrify -gaussian-blur ${BLUR}x${BLUR} $OUT
convert $MAP -page +0+$BY $OUT -flatten $OUT

#
# composite bar onto map
#
convert $OUT -page +0+$BY $BAR -flatten $OUT

#
# add QR code
#
MAP_WIDTH=$( identify $MAP | awk '{ print $3 }' | awk -F 'x' '{ print $1 }' )
QR_SIZE=$( identify $QR | awk '{ print $3 }' | awk -F 'x' '{ print $1 }')
let "GAP = $BAR_HEIGHT - $QR_SIZE"
let "MARGIN = $GAP / 2"
let "QY = $BY + $MARGIN"
let "QX = $MAP_WIDTH - $QR_SIZE - $MARGIN"
convert $OUT -page +$QX+$QY $QR -flatten $OUT

#
# add text
#
let "TY = $BY + 85"
convert $OUT -pointsize $POINT -font $FONT -fill $TEXTCOLOR -annotate +$MARGIN+$TY "Map Title\n\nAuthor 1\nAuthor 2\n\nProject Name\n\n@Twitter" $OUT
