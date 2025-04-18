
cat rp*/*.log | grep -P ',S?CALL,' | wc -l

cat rp*/*.log | grep -P ',S?CALL,' | gawk -vRS='[0-9]+:[0-9]+.[0-9]+-' '/S?CALL,.+,Context=/{print $0}'| gawk -F'-' '{print $2}' | sort -rnb | head

cat rp*/*.log | grep -P ',S?CALL,.+,Context=' | sed -r 's/^.{12}-//;s/S?CALL,*Context=//;s/,Interface=.*$//' | gawk -F'-' '{print $2}' | sort -rnb | head

cat rp*/*.log | grep -P '([3,4][0-9]|5[0-6]):.*,CALL,.+,Context=' | sed -r 's/^.{12}-//;s/CALL.*Context=//;s/,Interface=.*$//' | gawk -F',' '{D[$2]+=1} END {for(i in D) print D[i]":"i}' | sort -rnb | head

cat rp*/*.log | grep -P '([3,4][0-9]|5[0-6]):.*,CALL,.+,Context=' | gawk -vRS='[0-9]+:[0-9]+.[0-9]+-' '/S?CALL,.+,Context=/{print $0}' | sed -r 's/^.{12}-//;s/CALL.*Context=//;s/,Interface=.*$//' | gawk -F',' '{D[$2]+=1} END {for(i in D) print D[i]":"i}' | sort -rnb | head

-- https://its.1c.ru/db/metod8dev/content/6011/hdoc
cat rphost_*/*.log | awk -F\- '{print $2}' | awk -F\, '{sum[$2]+=$1;} END {for (event in sum) print event" - "sum[event];}'

-- замена символов конца строки, разделитель датавремя, замена конца строки и конца записи, контест раньше запроса, возврщаение пренеоса строки,  
-- нормазация и замена табуляциии пробелов, группировка - подсчет ощего времени исполнения и количество исполнений
cat rp*/*091[2-9].log | sed -r 's/,DBPOSTGRS,.+,Usr=/,S=/;s/,AppID=.+Sql=/,S=/;s/,RowsAffected=.+Context=/,S=/' | 
gawk -vORS='<!END!>' -vRS='[0-9]+:[0-9]+.[0-9]+-' '{print $0}' | gawk -vORS='<!ROWEND!>' '{print $0}' | gawk -vRS='<!END!>' '{print $0}' |
gawk -F '.S=' '{print $1 ".S=" $2 ".S=" $4 }' | gawk -vORS=' ' -vRS='<!ROWEND!>' '{print $0}' | sed -r 's/T[0-9]+./SomeTable./g;s/\t/ /g;s/ +/ /g' |
gawk -F '.S=' '{Array[$3]+=$1; Array2[$3]+=1} END {for(i in Array) print Array[i] ", " Array2[i] ":" i}' | sort -rnb | head -n 10 > 1.txt
