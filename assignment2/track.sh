#!/bin/bash

export LOGFILE='logfile.txt'

# Wrtiting start date and label to logfile.txt
function start() {
    STARTTIME=$(date)
    LABEL=$2
    echo "START: $STARTTIME" >> $LOGFILE
    echo "LABEL: This is Task $LABEL" >> $LOGFILE
}

# Writing stop date to logfile.txt and adding some blank space for readability
function stop() {
    STOPTIME=$(date)
    echo "END: $STOPTIME" >> $LOGFILE
    echo "" >> $LOGFILE
}

# Finds current status by checking if the last line in logfile.txt is LABEL
# Puts task number in $task and prints
function status() {
    STATUS=$(tail -n 1 $LOGFILE)
    if [[ "$STATUS" != "LABEL"* ]]; then
        echo "There is no active task"
    else
        TASK=$( echo $STATUS | cut -c21- )
        echo "Currently tracking task: $task"
    fi
}

# For task 2.3
# Removes ":" by using tr
# Returns the total time in seconds in the format HH:MM:SS
function return_sec() {
    read -r hours minutes seconds <<< $(echo $1 | tr ':' ' ')
    echo $(((hours*3600)+(minutes*60)+seconds))
}

# TASK 2.3 - displays the time spent on each task
# Using cut to get start time, label and end time
# Finding the difference in start and end time
function log() {
    while read -r LINE
    do
        if [[ "$LINE" == "START"* ]]; then
            STARTLINE=$( echo $LINE | cut -c21-28 )
        elif [[ "$LINE" == "LABEL"* ]]; then
            LABELLINE=$( echo $LINE | cut -c16- )
        elif [[ "$LINE" == "END"* ]]; then
            STOPLINE=$( echo $LINE | cut -c19-26 )
        else
            START=$(return_sec $STARTLINE)
            STOP=$(return_sec $STOPLINE)
            DIFF=$((STOP-START))
            echo "$LABELLINE: $((DIFF/3600)):$((DIFF%3600/60)):$((DIFF%60))"
        fi

    done < $LOGFILE
}

# Reads command from terminal
function track() {
    if [ "$1" == "start" ]; then
        LINE=$(tail -n 1 $LOGFILE)
        if [[ "$LINE" == "LABEL"* ]]; then
            echo "There is already a task running"
        else
            start $1 $2
        fi
    elif [ "$1" == "stop" ]; then
        stop
    elif [ "$1" == "status" ]; then
        status
    elif [ "$1" == "log" ]; then
        log
    fi
} 

# Specifies the usage in case any other arguments are given
# If not, calls track function
if [ $# == 0 ]; then
    echo "USAGE: track [start] [label]"
    echo "       track [status]"
    echo "       track [stop]"
    echo "       track [log]"
else
    track $1 $2
fi
