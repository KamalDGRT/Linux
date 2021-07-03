#!/bin/bash

# References: https://stackoverflow.com/a/60697438

dirName=~/bash_histories

if [ !-d $dirName ]; then
     if ! mkdir $dirName; then
          echo "Can't make dir: $dirName"
     fi
fi

history >~/"bash_histories/$(date +"%d_%m_%Y_._%I_%M_%S_%p")_bash_history.txt"
rm ~/.bash_history
history -c
history -w
exit
