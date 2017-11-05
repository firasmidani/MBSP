#!/bin/sh

#author Firas Said Midani
#e-mail firas.midani@duke.edu
#date 2017-11-5

#SEND_TO_BACK.sh accepts a shell scrips and executes in the background. 
# This prevents 'hagn-ups' if you log out or exis the instance. 
# output includes the output and errors re-directed form the terminal into two separate files, 
# and a .pid file that indicates the time stamp and pid of the submission

BASHSCRIPT=$1
TS=$(date +'%Y%m%d-%H%M%S');
FILENAMES=NOHUP_${BASHSCRIPT}_${TS}

nohup sh $BASHSCRIPT >$FILENAMES.out 2>$FILENAMES.err &

echo $BASHSCRIPT' submitted at '$TS' and assigned PID of '$! | tee $FILENAMES.pid
