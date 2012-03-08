#!/bin/ksh
echo ""
echo "=*=*= Processing the server log data for backup and summary. =*=*="
echo ""
# "=*=====================================================================*="
# cat is a file content display command, it shows results in the file.
# example. cat -b [objfile] shows the content of the 'file' with nonblank line number.
# example: cat -b ./tapelogg_1202071000.txt
# "=*=====================================================================*="
# grep is a keyword search command to find the sentences you want in a file.
# example. grep [options] -a PATTERN [objfile]
# example: grep -a '130' -f ./tapelogg_1202071000.txt list all lines that contain keyword 130.
# "=*=====================================================================*="
# sort -u sort the content and arrant the output in alphabetic order.
# "=*=====================================================================*="
# more display the output with pause each page.
# "=*=====================================================================*="
# tr is the translate command to change words in one file and write it to another. Like a replace.
# "=*=====================================================================*="
# for is the loop command used to do repeatable things.
# for x in "list"
# do
# ....
# done
# "=*=====================================================================*="
# awk is a conditional detecting function with feedback of text.
# example. awk '/pattern/ {excute function}'
# example: awk '/^$/ {print "This is a blank line"}'
# ^$ is a line terminator.
# "=*=====================================================================*="
# date command with "+%y%m%d%H%M" will show exactly the abbreviated info.
# like date "+%y%m%d%H%M" shows 1202101000.
# "=*=====================================================================*="
#
# dirlist_x.txt file is the original file that listed all the files based on the record from day 10 and 11.
# tapelogg_[date][time].txt file sort the dirlist_x.txt files everyday and list the parameters, data is updated till day 10.
# What we need to do is to 
# 1. Compare the two category files and find the missing computer name that is not recorded in the tapelogg file.
# (sort dirlist_?.txt files and compare them to the tapelogg_*.txt files, all dirlist_?.txt file is of same batch and tapelogg is daily.)
# 2. Create a file that summarize all the tapelogg_*.txt file content and keep the record for latest 30 days.
# (create a temporary file that only keep 30days record. It is a summary file of tapelogg_*.txt files. Keyword is the date)
# 3. Find the computer added or missing from last backup. Example, tapelogg_1202101000.txt kept the tract of backuped file from  .
# (compare the dirlist_?.txt content to the tapelogg_1202101000.txt to find the added or missing computers.)
# 4. Find the file size change.
# (compare the dirlist_?.txt file to the tapelogg_1202101000.txt on the size apsect to check the changes over 10%.)
# 5. Send this record to the persons on the mail list.
# (use mailx -s command)
# 6. Additional work, suggest how to handle error reports.
# Define directory path.
HOMEWORK_DIR=./
LOG_FILES_DIR=./oldtapelogs
DIRLIST_DIR=./dirfiles
TEMP_FILE_DIR=./summary
# Define file name style
OldTimeStamp=$(date "+%y%m%d%H%M")
NewTimeStamp=$(date "+Y%yM%mD%d_h%Hm%M")
OLD_LOG_FILE_NAME=tapelogg_$OldTimeStamp.txt
NEW_LOG_FILE_NAME=tapelogg_$NewTimeStamp.txt
#
DIR_FILE_NAME=dirlist_'"?"'.txt
DIR_LIST_GROUP=[a-d]
#
TEMP_FILE_NAME=templog_$NewTimeStamp.txt
integer DAYS=1
integer DAYS_MAX=31
IntmediateFile="try.txt"
while [[ $DAYS -lt $DAYS_MAX ]]
do
echo value DAYS: $DAYS
echo "Files from the last $DAYS days will be written to tape file." \ >> ${TEMP_FILE_DIR}/${TEMP_FILE_NAME}
((DAYS+=1))
done


# Start programming
while [[-z 'find ${LOG_FILES_DIR} -name "tapelogg*" -mtime -${DAYS} -type f -print']] \ && (($DAYS<$DAYS_MAX)); do
	((DAYS+=1))
done

echo "\nFiles from the last $DAYS days will be written to tape" \ >> ${TEMP_FILE_DIR}/${TEMP_FILE_NAME}

#List all files that will be written to tape, output to a temporary file
find ${LOG_FILES_DIR} -mtime -${DAYS_MAX} -type f | xargs ls -l > ${SUMMARY_FILE_DIR}/${SUMMARY_FILE_NAME}

# Total number of files in the new generated temporary file
# wc is the words count function, -l is the parameter that to count lines.
wc -l < ${SUMMARY_FILE_DIR}/${SUMMARY_FILE_NAME} | read NUM_OF_FILES
echo "\nNumber of files to be written to the record is ${NUM_OF_FILES}"\ >> ${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME}

# Total size of the record to be created on the tape
# WRITE HERE THE LOOP COMMAND
awk '{sum+=$5} END {printf ("%0f",sum)}' < ${SUMMARY_FILE_DIR}/${SUMMARY_FILE_NAME} | read NUM_OF_BYTES
awk '{sum+=$5} END {printf ("%0f",sum/1048576)}' < ${SUMMARY_FILE_DIR}/${SUMMARY_FILE_NAME} | read NUM_OF_MBYTES

echo "\n${NUM_OF_MBYTES} (equals to ${NUM_OF_BYTES} bytes) will be written to the record." >> ${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME}

# First rewind tape and then find the end of the data
mt -f ${LOG_FILE_DIR} rew
mt -f ${LOG_FILE_DIR} eod

echo "\nStart writting to record file ${NEW_LOG_FILE_NAME} at time: date" \ >> ${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME}

# Write all files that has been created since last DAYS
# The pax function will be used here to read and write files with directory information.
echo "\nFinished writing to record at time: date" \ >> ${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME}

# Remove files older than some 30 days.
echo "\nRemoving the following old files." \ >> ${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME}
find ${SUMMARY_FILE_DIR} -mtime +30 -type f -name *.bkf | xargs rm 2>>${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME}

# Mail the results to administrators
echo "$(<$(${SUMMARY_FILE_DIR}/${NEW_LOG_FILE_NAME})" | mailx -s \ "$0 $NUM_OF_MBYTES Mbytes $NUM_OF_FILES files" liangr@kth.se

# Remove the temporary file
rm 
