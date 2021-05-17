#!/bin/env bash

# chia-loop.sh - by nacelle (ellecan on github)

# exit on certain shell conditions that are unusual:
set -eu -o pipefail

# where are the plots generated?
# if you need to use multiple plot directories,
# set CHIAPLOTS="/firstdir -t /seconddir"
CHIAPLOTS=/chiatmp

# where are the plots stored?
CHIAFARM=/chia1

# how much memory should the chia process consume when sorting?
# (chia default is ~4GB)
CHIAMEM=6000

# how many cpu threads to use at any given time?
# (chia defualt is 2)
CHIATHREADS=4

# what k size of plot?  Almost everyone should be farming 
# k32 for a while
CHIASIZE=32

# touch the STOPFILE to stop chia after its finished up the plot
# its working on.  This is similar to pressing ctrl-c,
# except its much less messy and I think easier to control.
STOPFILE=~/stopplotting

# pre-round timeout
# I threw in this so that I can press ctrl-c on an errant script
# and have less consequence (user permissions on the chia directories, etc.)
PRETIMEOUT=2

# do rounds of chia:
round=0
while round="$(( round + 1 ))";do 
  # display the round
  echo "Round ${round}"

  # break out of the while loop if the stopfile is present:
  [ -f ${STOPFILE} ] && break

  
  # display how to stop this script properly 
  echo "touch ${STOPFILE} to stop plotting after this round"

  # throw up a small warning and prompt for ctrl-c
  echo "Wait ${PRETIMEOUT} seconds, press enter to continue,"
  read -t${PRETIMEOUT} -p"or press <ctrl-c> to stop now. "


  # Make a plot
  chia plots create -k ${CHIASIZE} -b ${CHIAMEM} \
  -r ${CHIATHREADS} -t ${CHIAPLOTS} -d ${CHIAFARM}
done
