c=74 # jg
#c=8 # gd
#wget -e robots=off -m --regex-type=pcre \
#	--accept-regex='(bt.etree.org/details.php\?id=\d+$)|(bt.etree.org/index.php\?cat='$c'&page=\d+$)|(.*torrent$)' \
#	http://bt.etree.org/index.php?cat=$c
#wget -e robots=off -m --regex-type=pcre \
#	--accept-regex='(bt.etree.org/details.php\?id=\d+$)|(bt.etree.org/index.php\?cat='$c'&incldead=1&page=\d+$)|(.*torrent$)' \
#	"http://bt.etree.org/index.php?cat=$c&incldead=1"

# search
wget -e robots=off -m --regex-type=pcre \
    --accept-regex='(.*etree.org/details.php\?id=\d+$)|(.*etree.org/index.php\?searchzzzz=Grisman&cat&incldead=1&page=\d+$)|(.*torrent$)' \
    "http://etree.org/index.php?searchzzzz=Grisman&cat&incldead=1&page=0"
