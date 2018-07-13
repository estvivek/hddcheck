

#!/bin/bash
# Troubleshoot.sh
# A more elaborate version of Troubleshoot.sh.

SUCCESS=0
E_DB=99    # Error code for missing entry.

declare -A address
#       -A option declares associative array.



if [ -f Troubleshoot.log ]
then
    rm Troubleshoot.log
fi

if [ -f HDs.log ]
then
    rm HDs.log
fi

smartctl --scan | awk '{print $1}' >> HDs.log
lspci | grep -i raid >> HDs.log

getArray ()
{
    i=0
    while read line # Read a line
    do
        array[i]=$line # Put it into the array
        i=$(($i + 1))
    done < $1
}

getArray "HDs.log"


for e in "${array[@]}"
do
    if [[ $e =~ /dev/sd* || $e =~ /dev/hd* ]]
        then
            echo "smartctl -i -A $e" >> Troubleshoot.log
            smartctl -i -A $e >> Troubleshoot.log # Run smartctl into all disks that the host have
    fi
done
exit $?   # In this case, exit code = 99, since that is function return.
