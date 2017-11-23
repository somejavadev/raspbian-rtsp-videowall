#!/bin/bash

# Basic RTSP video wall script.
#
# Creates $SIZE amount of 'screen' sessions each presenting a RTSP feed from the rtsp.feed
# file. The script will make use of raspbian's tvservice to determine the current screen resolution and
# divide the screen in equal size screens (totalling $SIZE).
#
# To kill all feeds, kill all screen processes: killall omxplayer; killall screen;
#
# The following dependencies are required:
# - bc
# - screen
# - omxplayer
#
# To install these on raspbian, as root: apt install omxplayer && apt install screen && apt install bc
# Tested on raspbian stretch.

SCREEN_INFO=`tvservice -s | grep -o "[0-9]*x[0-9]* @ [0-9]*\.[0-9]*[H\h][Z|z]"`;
SCREEN_WIDTH=`echo $SCREEN_INFO | grep -o ^[0-9]*`
SCREEN_HEIGHT=`echo $SCREEN_INFO | grep -oP "(?<=x)[0-9]*"`

echo "Screen height is: $SCREEN_HEIGHT and screen width is: $SCREEN_WIDTH";

# Change this to the amount of RTSP feeds you have. The number should be a number closest to a perfect square number (rounded up from your feed count).
# eg. 1, 4, 9, 16, 25.
# 3 feeds = 4, 5 feeds = 9, 11 feeds = 16.
SIZE=4;

X_BY_Y=$(bc <<< "scale=0; sqrt($SIZE)")
echo "X and Y total: $X_BY_Y";

WIDTH_JUMP=$(bc <<< "scale=0; $SCREEN_WIDTH/$X_BY_Y");
HEIGHT_JUMP=$(bc <<< "scale=0; $SCREEN_HEIGHT/$X_BY_Y");

echo "width_jump = $WIDTH_JUMP";
echo "height_jump = $HEIGHT_JUMP";

X_START_INDEX=0;
Y_START_INDEX=0;
WALL_ID=1;

for ((row = 1; row <= $X_BY_Y; row++)); do

        for ((col = 1; col <= $X_BY_Y; col++)); do
                echo "wall id = $WALL_ID, row = $row, col = $col";

                FEED=$(sed "$WALL_ID"'q;d' rtsp.feed)
                echo $FEED;

                X_END_INDEX=$(bc <<< "scale=0; $X_START_INDEX+$WIDTH_JUMP");
                Y_END_INDEX=$(bc <<< "scale=0; $Y_START_INDEX+$HEIGHT_JUMP")

                LAUNCH_SCREEN="\"screen -dmS wall-feed-$WALL_ID sh -c 'omxplayer --avdict rtsp_transport:tcp $FEED --live --win $X_START_INDEX,$Y_START_INDEX,$X_END_INDEX,$Y_END_INDEX -n -1'\"";

                WALL_ID=$(bc <<< "$WALL_ID + 1");

                echo "$LAUNCH_SCREEN"

                eval eval '$'$LAUNCH_SCREEN

                X_START_INDEX=$(bc <<< "$X_START_INDEX + $WIDTH_JUMP")
        done

        Y_START_INDEX=$(bc <<< "$Y_START_INDEX + $HEIGHT_JUMP");
        X_START_INDEX=0;
done