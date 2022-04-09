#!/bin/bash

currentDirectory=$(pwd)
emptysubs=~/RKS_FILES/GitRep/Linux/common/shell/emptysubs.sh
batchmux=~/RKS_FILES/GitRep/Linux/common/shell/batchmux.sh

# cd "${currentDirectory}"

printf "Moving subtitles to the muxed folder\n"
mv *.srt mux/

printf "Removing mp4 present in the current directory\n"
rm *.mp4

printf "Moving the h265 muxed files to the current directory\n"
mv mux/* .

printf "Removing the mux/ folder\n"
rmdir mux/

printf "Merging the mp4 and srt to create mkv\n"
$batchmux -c 'mp4' -s 'srt'

printf "Removing mp4 and srt files in the current directory\n"
rm *.mp4 *.srt

printf "Moving the muxed files to the current directory\n"
mv bmuxmp4/* .

printf "Removing bmuxmp4\n"
rmdir bmuxmp4/
