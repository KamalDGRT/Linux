mkdir mux;
for i in *.mp4;
  do name=`echo "$i" | cut -d'.' -f1`
    echo "${name}.mp4"
    echo ""
    ffmpeg -i "$i" -c:v libx265 -vtag hvc1 "mux/${name}.mp4" -v quiet -stats
    echo "${name}.mp4 has been converted to h265 fomat."
    echo ""
done

