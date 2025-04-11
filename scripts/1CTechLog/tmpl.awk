
cat rp*/*.log | grep -P ',S?CALL,' | wc -l

cat rp*/*.log | grep -P ',S?CALL,' | gawk -vRS='[0-9]+:[0-9]+.[0-9]+-' '/S?CALL,.+,Context=/{print $0}'| gawk -F'-' '{print $2}' | sort -rnb | head

cat rp*/*.log | grep -P ',S?CALL,.+,Context=' | sed -r 's/^.{12}-//;s/S?CALL,*Context=//;s/,Interface=.*$//' | gawk -F'-' '{print $2}' | sort -rnb | head

cat rp*/*.log | grep -P '([3,4][0-9]|5[0-6]):.*,CALL,.+,Context=' | sed -r 's/^.{12}-//;s/CALL.*Context=//;s/,Interface=.*$//' | gawk -F',' '{D[$2]+=1} END {for(i in D) print D[i]":"i}' | sort -rnb | head

cat rp*/*.log | grep -P '([3,4][0-9]|5[0-6]):.*,CALL,.+,Context=' | gawk -vRS='[0-9]+:[0-9]+.[0-9]+-' '/S?CALL,.+,Context=/{print $0}' | sed -r 's/^.{12}-//;s/CALL.*Context=//;s/,Interface=.*$//' | gawk -F',' '{D[$2]+=1} END {for(i in D) print D[i]":"i}' | sort -rnb | head


// замена символов конца строки, пересноса строки, далее группировка контекст, запрос
cat rp*/*091[2-9].log | sed -r 's/,DBPOSTGRS,.+,Usr=/,S=/;s/,AppID=.+Sql=/,S=/;s/,RowsAffected=.+Context=/,S=/' | 
 gawk -vORS='<!END!>' -vRS='[0-9]+:[0-9]+.[0-9]+-' '{print $0}' | gawk -vORS='<!ROWEND!>' '{print $0}' | gawk -vRS='<!END!>' '{print $0}' |
gawk -F '.S=' '{print $1 ".S=" $2 ".S=" $4 ".textSQL=" $3}' |
gawk -F '.S=' '{Array[$3]+=$1} END {for(i in Array) print Array[i] ":" i}' | sort -rnb | head | gawk -vORS=' ' -vRS='<!ROWEND!>' '{print $0}' > 1.txt
