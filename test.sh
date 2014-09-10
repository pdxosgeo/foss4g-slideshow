#!/bin/sh

PATH="/bin:/usr/bin:/usr/local/bin"

IMG=$1
URL=$2
TITLE=$3
NAME=$4
TWITTER=$5

MAP="in/$IMG"
BAR="bar.png"
QR="qr/$IMG"
OUT="out/$IMG"
TEXTCOLOR="white"
STROKECOLOR="black"
LARGEFONT="Arvo-Bold.ttf"
SMALLFONT="Arvo.ttf"
LARGEPOINT=50
SMALLPOINT=45
BLUR=5

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
qrencode -o $QR -s 10 -m 2 $URL
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
convert $OUT \
    -pointsize $LARGEPOINT \
    -font $LARGEFONT \
    -fill $TEXTCOLOR \
    -stroke black \
    -strokewidth 1 \
    -annotate +$MARGIN+$TY "$TITLE" \
    -pointsize $SMALLPOINT \
    -font $SMALLFONT \
    -fill $TEXTCOLOR \
    -stroke black \
    -strokewidth 1 \
    -annotate +$MARGIN+$TY "\n\nAuthor: ${NAME}\n\n${TWITTER}" \
    +append $OUT

#
# clean up
#
rm -f ${OUT}~*
