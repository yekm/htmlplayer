# cd /mnt/huanan/music/torrent/done

for d in gd grisman jg ; do
    cd $d
    rxml.sh cache | \
        cut -f 3,6,5 | \
        grep -P '\s1.00\s' | \
        cut -f 1,3 | \
        grep -e "$d$" | \
        cut -f1 | \
        sed 's,/mnt/../torrent,../..,' | \
        xargs -d'\n' -n1 ln -s
    cd ..
done

# find -L . | sort | ~/go/src/fsjson/fsjson > fs.json

