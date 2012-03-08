#!/bin/bash
tape_log=taplogg_$(date "+%y%m%d%H%M").txt
current_dir=`pwd`
if [ -d "temp_dir" ]; then
   rm -rf temp_dir
fi
mkdir temp_dir
dir=$current_dir/temp_dir

echo "" >> $dir/$tape_log
echo "Files is written to the tape from the `date -d '1 day ago' +'%Y/%m/%d/%H:%M'`." > $dir/$tape_log
no_of_files=`cat ../dirfiles/* |  sort | uniq | wc -l`

echo "" >> $dir/$tape_log
echo "Number of files to be written to the tape is: $no_of_files" >> $dir/$tape_log 
noofbytes=`cat ../dirfiles/* | sort | uniq| awk '{sum+=$5}END{printf(sum) }'`
noofmbytes=`cat ../dirfiles/* | sort | uniq| awk '{sum+=$5}END{printf(sum/1048576) }'`
echo "" >> $dir/$tape_log
echo "Number of Mbytes to be written to the tape is: $noofmbytes (eq to $noofbytes bytes) " >> $dir/$tape_log 
echo "" >> $dir/$tape_log
echo -e  "size (byte) \t\t  backup computer" >> $dir/$tape_log
echo "" >> $dir/$tape_log
echo "" >> $dir/$tape_log
cat ../dirfiles/* | awk '{print $5"\t\t"$9}' | sort | uniq  >> $dir/$tape_log

