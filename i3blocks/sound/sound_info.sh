#!/bin/sh

case $BLOCK_BUTTON in
  3) pactl set-sink-mute @DEFAULT_SINK@ toggle ;; # right click
  4) pactl set-sink-volume @DEFAULT_SINK@ +10% ;; # scroll up
  5) pactl set-sink-volume @DEFAULT_SINK@ -10% ;; # scroll down, decrease
esac

VOLUME_MUTE="🔇"
VOLUME_LOW="🔈"
VOLUME_MID="🔉"
VOLUME_HIGH="🔊"
SOUND_LEVEL=$(amixer -D pulse -M get Master | awk -F"[][]" '/%/ { print $2 }' | awk -F"%" 'BEGIN{tot=0; i=0} {i++; tot+=$1} END{printf("%s\n", tot/i) }')
MUTED=$(amixer -D pulse get Master | awk ' /%/{print ($NF=="[off]" ? 1 : 0); exit;}')

ICON=$VOLUME_MUTE
if [ "$MUTED" = "1" ]
then
    ICON="$VOLUME_MUTE"
else
    if [ "$SOUND_LEVEL" -lt 34 ]
    then
        ICON="$VOLUME_LOW"
    elif [ "$SOUND_LEVEL" -lt 67 ]
    then
        ICON="$VOLUME_MID"
    else
        ICON="$VOLUME_HIGH"
    fi
fi

echo "$ICON" "$SOUND_LEVEL" | awk '{ printf(" %s %3s%% \n", $1, $2) }'

