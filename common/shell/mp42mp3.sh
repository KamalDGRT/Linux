#!/bin/bash

# Creating directory to store the output files
if [[ ! -d newmp3/ ]]; then
    mkdir newmp3
    echo "Creating newmp3/ to store the output of ffmpeg"
    echo ""
fi

count=1

# Traversing throuugh the matroska files present in the directory
for file in *.mp4; do
    name=$(echo "$file")
    clean_name="${name%.mp4}"
    directory=$(pwd)
    inputfile="${directory}/${name}"
    outputfile="${clean_name}_1.mp3"
    outputfilepath="${directory}/newmp3/${outputfile}"
    finalname="${clean_name}.mp3"

    echo "File Number   : ${count}"
    echo "Input File    : ${inputfile}"
    echo "Output File   : ${outputfile}"
    echo ""

    echo "Creating the mp3 file using ffmpeg"
    ffmpeg -i "${inputfile}" -b:a 320K "${outputfilepath}" -v quiet -stats
    mv "newmp3/${outputfile}" "newmp3/${finalname}"
    echo ""
    echo "-------------------------------------------------------------"
    echo ""

    count=$(expr $count + 1)
done
