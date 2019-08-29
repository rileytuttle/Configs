#!/bin/bash

IFS=':' read -r -a INPUT <<< "$1"
FILE=${INPUT[0]}
CENTER=${INPUT[1]}
HALFHEIGHT=$(( FZF_HEIGHT / 2 ))
#echo halfheight=$HALFHEIGHT
if [ $CENTER -gt $HALFHEIGHT ]; then
	FIRSTLINE=$(( CENTER - HALFHEIGHT ))
else
	FIRSTLINE=$CENTER
fi
#echo firstline=$FIRSTLINE
#echo "bat --style=numbers --color=always $FILE | less +$FIRSTLINE"
cmd='bat --style=numbers --color=always --pager ''"less +'"$FIRSTLINE"'p"'" $FILE"
#cmd="~/bat/target/debug/bat --style=numbers --color=always --pager \"less\" $FILE"
echo $cmd
eval $cmd

# figure out a way to center bat on a specific line
