#!/bin/bash

history > ~/"bash_histories/$(date +"%d_%m_%Y_._%I_%M_%S_%p")_bash_history.txt"
rm ~/.bash_history
history -c
history -w
exit
