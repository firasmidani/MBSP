#!/bin/sh

#author Firas Said Midani
#e-mail firas.midani@duke.edu
#date 2017-11-5

#SEND_TO_BACK.sh accepts a shell script and executes in the background. 
# This prevents 'hagn-ups' if you log out or exit the instance. 
# It also redirects the output and errors form the terminal into two separate files, 
# and creates a .pid file that indicates the time stamp and ProcessID of the submission
#
# you can check your running processes with 'ps ux -H' in the terminal

BASHSCRIPT=$1
TS=$(date +'%Y%m%d-%H%M%S');
FILENAMES=NOHUP_${BASHSCRIPT}_${TS}

nohup sh $BASHSCRIPT >$FILENAMES.out 2>$FILENAMES.err &

echo $BASHSCRIPT' submitted at '$TS' and assigned PID of '$! | tee $FILENAMES.pid
