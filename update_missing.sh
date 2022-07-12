echo -e "updated $(date '+%F %R')\n\n" >missing.txt
rxml.sh cache | cut -f2,5,6 | awk '{print $3 " " $1 " " $2}' | grep '0.00$' | sort | cut -f 1,2 -d' ' | tee -a missing.txt
