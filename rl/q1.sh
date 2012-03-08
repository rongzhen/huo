#!/bin/ksh
echo ""
echo "=*=*= Processing the server log data for backup and summary. =*=*="
echo ""
LOG_FILES_DIR=./oldtapelogs
DIRLIST_DIR=./dirfiles
TEMP_FILE_DIR=./summary
# Define the time stamp parameter for file creation.
OldTimeStamp=$(date "+%y%m%d%H%M")
NewTimeStamp=$(date "+Y%yM%mD%d_h%Hm%M")
OLD_LOG_FILE_NAME=tapelogg_$OldTimeStamp.txt
NEW_LOG_FILE_NAME=tapelogg_$NewTimeStamp.txt
# Define the dirlist_x file naming style.
DIR_LIST_GROUP=[a-d]
DIR_FILE_NAME=dirlist_"$DIR_LIST_GROUP".txt
#DIR_FILE_NAME=dirlist_"$?".txt
# Test the definition.
TEMP_FILE_NAME=templog_"$NewTimeStamp".txt
integer DAYS=1
integer DAYS_MAX=30
IntmediateFile="try.txt"
echo $DIR_FILE_NAME

while [[ (-n $(find ${LOG_FILES_DIR} -name "*tapelogg*" -mtime +${DAYS} -type f -print)) && ($DAYS -le $DAYS_MAX) ]]
do
((DAYS+=1))
done
echo "Files from the last $DAYS days will be written to tape file." \ >> ${TEMP_FILE_DIR}/${TEMP_FILE_NAME}
