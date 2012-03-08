#!/bin/bash
i=1
temp=`grep  "/home.*zip" tapelogg_1202091000.txt | wc -l`  
#grep  "/home.*zip" tapelogg_1202101000.txt | sed -n "$i p" | awk 'BEGIN {FS="\/"} {print $4}' |xargs -i bash -c ' grep  "{}" tapelogg_1202091000.txt' 

for ((i=1;i<=$temp;i=i+1))
do
echo "------------------------------------------"
tempname=`grep  "/home.*zip" tapelogg_1202091000.txt | sed -n "$i p" | awk 'BEGIN {FS="\/"} {print $4}' `
grep  "/home.*zip" tapelogg_1202091000.txt | sed -n "$i p" | awk 'BEGIN {FS="\/"} {print $4}' |xargs -i bash -c ' grep  "{}" tapelogg_1202111000.txt' 
if [ "$?" == "0" ]; then 
echo "$(tput setaf 2)computer: $tempname already exist before"
echo "------------------------------------------"
else
echo " $(tput setaf 1) computer: $tempname does not exist"
echo "------------------------------------------"
fi
sleep 1
done
