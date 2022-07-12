#!/bin/bash

# time find -L done -type f | parallel --progress -n1 -d'\n' bash ./special_opus.sh

set -u

odir="./opus"

f="$1"
ext=${f##*.}
notop=$(echo "$f" | cut -f2- -d/)

case $ext in
flac|shn)

    opus=$odir/${notop%.*}.opus
    [ -s "$opus" ] && exit
    mkdir -p "$(dirname "$opus")"

    ffmpeg -y -hide_banner -nostdin -loglevel warning \
        -i "$f" \
        -map_metadata 0 \
        -c:a libopus -b:a 96k \
        "$opus"
;;
txt|jpg|png)
    nd=$(dirname "$odir/$notop")
    mkdir -p "$nd"
    cp "$f" "$nd"
;;
*)
    echo skip $f
esac
