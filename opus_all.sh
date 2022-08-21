#!/bin/bash

#find -L ../done -mindepth 3 -maxdepth 3 -type d | parallel --progress -n1 -j150% bash ~/bin/opus_all.sh

set -ue

ffjson() {
    ffprobe -v quiet -print_format json -show_format -show_streams "$1"
}

log() {
    echo "$o: $@" | tee -a .log
}
export -f ffjson

o="$(basename "$1").opus"

if [ -s "$o" ] ; then
    # check if existing file is fully encoded
    duration_original=$(find "$1" -type f -iname "*.flac" -o -iname "*.shn" | parallel -k "ffjson {} | jq -r '.streams[].duration'" | paste -sd+ | bc -l)
    duration_opus=$(ffjson $o | jq -r '.streams[].duration')
    ddiff=$(echo -e "$duration_original\n$duration_opus" | sort -rn | paste -sd- | bc -l)
    if (( `bc -lq <<< "$ddiff > 2.0"` )) ; then
        # if the difference between existing opus and sum of original files is bigger then 2 seconds then reencode
        log "$ddiff $(du -sh $o) reencoding"
    else
        log "$ddiff leaving"
        exit
    fi
else
    log "new"
fi

exit

t=$(mktemp .opustmp.XXXXXXXXXXXX)

trap 'rm -v $t* $o' INT TERM

i=0
find "$1" -maxdepth 1 -type f -iname "*.flac" -o -iname "*.shn" | sort | while read f; do
	rp=$(realpath "$f")
	ln -sf "$rp" $t.$i.tmp
	echo "file '$t.$i.tmp'"
	let 'i = i + 1'
done > $t.txt
#ls -la $t*
#ls /tmp/*.tmp.ffmpeg.opus | sort -n | sed "s/^/file '/; s/$/'/;" | tee $t

sem --id vmt vmtouch -qtf $t.*.tmp

ffmpeg -y -hide_banner -nostdin -loglevel warning \
	-f concat -safe 0 -i $t.txt \
	-map_metadata 0 \
	-c:a libopus -b:a 128k \
	"$o"

vmtouch -qef $t.*.tmp
[ -z "${NORMTMP+x}" ] && rm $t*
