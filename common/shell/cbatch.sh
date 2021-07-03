#!/bin/bash

mkdir mux
for i in *.mp4; do
    name=$(echo "$i")
    echo "${name}"
    echo ""
    ffmpeg -i "$i" -c:v libx265 -vtag hvc1 "mux/${name}" -v quiet -stats
    echo "${name} has been converted to h265 fomat."
    echo ""
done
