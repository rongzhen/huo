#!/bin/bash
LOG_FILES_DIR=`pwd`/temp_dir
DAYS_MAX=30
add_file=`pwd`/report/add_$(date "+%y%m%d%H%M").txt
miss_file=`pwd`/report/miss_$(date "+%y%m%d%H%M").txt
error_file=`pwd`/report/error_$(date "+%y%m%d%H%M").txt
IN=$(find ${LOG_FILES_DIR} -name 'tapelogg*' -mtime -$DAYS_MAX -type f -print | sort )
arr=$(echo $IN | tr "\ " "\n")
j=1
for x in $arr
do
    tape[j]=$x
    echo ${tape[j]}
    ((j+=1))
done

###################check the tapelogg file###################
temp=`grep  "alf.*zip" ${tape[j-1]} | wc -l`
for ((i=1;i<=$temp;i=i+1))
do
tempname2=`grep  "alf.*zip" ${tape[j-1]} | sed -n "$i p" | awk 'BEGIN {FS="\/"} {print $2}' `

findrow=`grep -rin $tempname2  ${tape[j-1]} | wc -l`
if [ $findrow \> 1 ]; then
echo "There is something wrong with computer: $tempname2 in the file ${tape[j-1]}"  >> $error_file 2>&1 
exit 1
fi
done

###################find the new computer######################
temp=`grep  "alf.*zip" ${tape[j-1]} | wc -l`
#for ((i=1;i<=$temp;i=i+1))
for ((i=1;i<=6;i=i+1))
do
tempname2=`grep  "alf.*zip" ${tape[j-1]} | sed -n "$i p" | awk 'BEGIN {FS="\/"} {print $2}' `
tempsize2=`grep  "alf.*zip" ${tape[j-1]} | sed -n "$i p" | awk 'BEGIN {FS=" "} {print $1}' `

findflag=`grep $tempname2  ${tape[j-2]}`
if [ "$?" == "0" ]; then
#echo "computer: $tempname2 already exist on yesterday"  > $add_file 2>&1 
tempsize1=`grep  $tempname2  ${tape[j-2]} | awk 'BEGIN {FS=" "} {print $1}' `
sizem=$(($tempsize1-$tempsize2))
sizer1=$(($sizem/$tempsize1))
sizer=`echo "scale=4; $sizem/$tempsize1*10" | bc | nawk '{ print ($1 >= 0) ? $1 : 0 - $1}'`
   if [ $sizer \> 1 ];then
      echo " backup file size of computer $tempname2  changed by more than -/+10%" >> $add_file 2>&1
   fi 
else
   echo "computer: $tempname2 does not exist before"     >> $add_file 2>&1
fi

done

###################find the missed computer######################
temp=`grep  "alf.*zip" ${tape[j-2]} | wc -l`
for ((i=1;i<=$temp;i=i+1))
do
tempname2=`grep  "alf.*zip" ${tape[j-2]} | sed -n "$i p" | awk 'BEGIN {FS="\/"} {print $2}' `
findflag=`grep $tempname2  ${tape[j-1]}`
if [ "$?" != "0" ]; then
echo "computer: $tempname2 is missed now" >> $miss_file 2>&1
fi
done
