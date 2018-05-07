#!/bin/bash
# rotate screen and touch screen

INPUT_DEVICES=( 'Wacom HID 482F Finger touch' 'Wacom HID 482F Pen stylus' )
TRANSFORM_TYPE='Coordinate Transformation Matrix'

DIRECTION=$1

# pick the transformation matrix for our rotation
#case "$DIRECTION" in
#    "normal") TRANS_MATRIX="1 0 0 0 1 0 0 0 1";;
#    "inverted") TRANS_MATRIX="-1 0 1 0 -1 1 0 0 1";;
#    "left") TRANS_MATRIX="0 -1 1 1 0 0 0 0 1";;
#    "right") TRANS_MATRIX="0 1 0 -1 0 1 0 0 1";;
#esac


case "$DIRECTION" in
    "normal") TRANS=0;;
    "inverted") TRANS=3;;
    "left") TRANS=2;;
    "right") TRANS=1;;
esac

# perform the rotation for all relevant input devices
for DEVICE in "${INPUT_DEVICES[@]}"
do
    echo "rotating input device: \"$DEVICE\""
    #xinput set-prop "$DEVICE" "$TRANSFORM_TYPE" $TRANS_MATRIX
    xsetwacom --set "$DEVICE" Rotate $TRANS
done

# perform the rotation on the display
#xrandr --output eDP-1 --rotate $DIRECTION
xrandr --output eDP1 --rotate $DIRECTION


