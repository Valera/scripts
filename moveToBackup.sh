#####!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
    echo "Wrong number of arguments, expecting et least 1, got $#" 1>&2
    exit 2;
fi

BACKUP_DIR=$HOME/backup

TODAY=`date '+%Y.%m.%d'`
DIR=$BACKUP_DIR/$TODAY
mkdir -p $DIR
echo "Writing backups to directory $DIR"

suffixName () {
    if [ "$#" != 2 ]; then
        echo "Wrong number of arguments, expecting 2, got $#" 1>&2
        return 2;
    fi
    FNAME=${1}${2}
    if [ -f $FNAME ]; then
        for i in `seq 2 10`
        do
            FNAME=${1}_${i}${2}
            if ! [ -f "$FNAME" ]; then
                echo "$FNAME"
                return 0;
            fi
        done
        # If function got here, 100 files with suffixes exist; Something is wrong.
        echo "ERROR: Can't find proper suffix in range 2:10." 1>&2 #Error report ro stderr.
        echo #empty string
        return 1;
    else
        echo "${1}${2}"
        return 0;
    fi
}

for i in "$@"
do
    FNAME=`basename "$i"`
    FNAME=`suffixName $DIR/$i .tar.bz2`
    if [ x$? = x0 ]; then
        echo tar -cjf $FNAME $i
        tar -cjf "$FNAME" "$i"
    fi
done


