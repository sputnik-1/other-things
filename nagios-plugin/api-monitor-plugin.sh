#!/bin/bash

# the full filepath and name of the log file to search.
LOG_FILE="/home/keith.roberts/portal-api-logs/portal-testlog.log"

# string to search for backwards from the end of the log file.
SEARCH_STRING="portal"

# number of lines to search backwards from the end of the file.
# fine tune this depending on how many number of lines you want
# to search backwards through the log for SEARCH_STRING
RANGE=50

#==============================================================
# debug code defaults to off
DEBUG="0"

# DEBUG=0 - debugging off
# DEBUG=1 - debugging on
# uncomment to turn debug code on
# DEBUG="1"


# debug code block
if (($DEBUG ==1))
   then

echo;
echo "DEBUG: $DEBUG"
echo "LOG_FILE: $LOG_FILE"
echo "SEARCH_STRING: $SEARCH_STRING"
echo "RANGE: $RANGE"
echo;

echo "# get all instances of the string from the last X number of lines in the file"
echo "sed -e :a -e '\$q;N;'\"\$RANGE\"',\$D;ba' \"\$LOG_FILE\" | grep \"\$SEARCH_STRING\""

sed -e :a -e '$q;N;'"$RANGE"',$D;ba' "$LOG_FILE" | grep "$SEARCH_STRING"

echo;

echo "# return a count of all instances of the string found from the last X number of lines in the file"
echo "sed -e :a -e '\$q;N;'\"\$RANGE\"',\$D;ba' \"\$LOG_FILE\" | grep -c \"\$SEARCH_STRING\""
echo;
echo "LOG_FILE: $LOG_FILE"
echo "SEARCH_STRING: $SEARCH_STRING"
echo "RANGE: $RANGE"

fi

# end debug code
#==============================================================

FOUND=`sed -e :a -e '$q;N;'"$RANGE"',$D;ba' "$LOG_FILE" | grep -c "$SEARCH_STRING"`

if (($FOUND >=1))
   then EXIT_CODE="0"
else
   EXIT_CODE="2"
fi

if (($DEBUG ==1))
   then
echo "FOUND: $FOUND"
echo "EXIT_CODE: $EXIT_CODE"
echo;
fi

case $EXIT_CODE in
[0]*) echo -e "OK: the portal-api daemon is running fine."
exit 0
;;

[2]*) echo -e "CRITICAL: is the portal-api daemon up and running?"
exit 2
;;
esac

exit
