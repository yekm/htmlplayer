# cd /mnt/huanan/music/torrent/done

for d in gd grisman jg ; do
    cd $d
    rxml.sh cache | \
        cut -f 3,6,5 | \
        grep -P '\s1.00\s' | \
        cut -f 1,3 | \
        grep -e "$d$" | \
        cut -f1 | \
        sed 's,/mnt/[^/]*/torrent,../..,' | \
        parallel ln -s
    cd ..
done

cd ../all
find -L ../done -mindepth 3 -maxdepth 3 -type d | parallel ln -s
ls -d ??19??-??-??* | parallel 'mv -v {} $(echo {} | sed "s/^\(..\)19\(..-..-..\)/\1\2/")'

# time find -L . -mindepth 2 | sort | ~/go/src/fsjson/fsjson > fs.json

