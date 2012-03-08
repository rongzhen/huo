#/bin/bash

#DEVICE_FIL=/dev/rmt/0mn??
#ROTKATALOG=/home/rongzhen/Downloads/Unix/unix_hw1/oldtapelogs
ROTKATALOG=/home/rongzhen/Downloads/Unix/unix_hw1/summary


TAPE_LOGG=tapelogg_`date "+%y%m%d%H%M"`.txt

DAYS=1
DAYS_MAX=21
while [[ (-n $(find ${ROTKATALOG} -name "*tapelogg*" -mtime +${DAYS} -type f -print)) && ($DAYS -le $DAYS_MAX) ]]

do
   DAYS=$(($DAYS+1))
done

echo "Files from the last $DAYS days will be written to tape." >> ${ROTKATALOG}/${TAPE_LOGG}


