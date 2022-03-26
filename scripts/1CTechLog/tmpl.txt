
cat rp*/*.log | grep -P ',S?CALL,' | wc -l

cat rp*/*.log | grep -P ',S?CALL,' | gawk -vRS='[0-9]+:[0-9]+.[0-9]+-' '/S?CALL,.+,Context=/{print $0}'| gawk -F'-' '{print $2}' | sort -rnb | head

cat rp*/*.log | grep -P ',S?CALL,.+,Context=' | sed -r 's/^.{12}-//;s/S?CALL,*Context=//;s/,Interface=.*$//' | gawk -F'-' '{print $2}' | sort -rnb | head

cat rp*/*.log | grep -P '([3,4][0-9]|5[0-6]):.*,CALL,.+,Context=' | sed -r 's/^.{12}-//;s/CALL.*Context=//;s/,Interface=.*$//' | gawk -F',' '{D[$2]+=1} END {for(i in D) print D[i]":"i}' | sort -rnb | head

cat rp*/*.log | grep -P '([3,4][0-9]|5[0-6]):.*,CALL,.+,Context=' | gawk -vRS='[0-9]+:[0-9]+.[0-9]+-' '/S?CALL,.+,Context=/{print $0}' | sed -r 's/^.{12}-//;s/CALL.*Context=//;s/,Interface=.*$//' | gawk -F',' '{D[$2]+=1} END {for(i in D) print D[i]":"i}' | sort -rnb | head

